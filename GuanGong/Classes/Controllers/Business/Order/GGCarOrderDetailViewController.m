//
//  GGCarOrderDetailViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/30.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarOrderDetailViewController.h"
#import "GGCarOrderProgressView.h"
#import "GGCarOrderBottomView.h"

#import "GGNewCarOrderBaseInfoCell.h"
#import "GGCarOrderBaseInfoCell.h"
#import "GGCarOrderPriceCell.h"
#import "GGCarOrderOtherInfoCell.h"

#import "GGTransferDetailViewController.h"
#import "GGCheckCardIDViewController.h"
#import "GGModifyPriceViewController.h"
#import "GGRefundmentViewController.h"

#import "GGPaymentCodeView.h"
#import "GGCarOrderViewModel.h"
#import "GGOtherPayDetailViewModel.h"

#import "GGVehicleDetailsViewController.h"
#import "GGNewCarDetailViewController.h"



@interface GGCarOrderDetailViewController ()<GGPaymentCodeDelegate,CarOrderDetailButtonViewDelegate>

@property(nonatomic,strong)GGPaymentCodeView *codeView;
@property(nonatomic,strong)GGCarOrderProgressView *headerView;
@property(nonatomic,strong)GGCarOrderBottomView *bootomView;

@property(nonatomic,strong)GGCarOrderViewModel *carOrderVM;
@property(nonatomic,strong)GGOtherPayDetailViewModel *otherPayVM;

@property(nonatomic,assign)NSInteger sectionCount;

@property(nonatomic,strong)NSTimer *timer;

@end

@implementation GGCarOrderDetailViewController

- (instancetype)initWithObject:(GGCarOrderDetail *)obj
{
    if (self = [super init]) {
        self.carOrderVM.orderDetail = obj;
    }
    return self;
}

- (void)bindViewModel
{
    @weakify(self);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[self.carOrderVM.orderDetailCommand execute:nil] subscribeError:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } completed:^{
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
    [[RACObserve(self.carOrderVM, orderDetail) skip:1] subscribeNext:^(GGCarOrderDetail *orderDetail) {
        @strongify(self);
        
        self.sectionCount = 3;
        self.headerView.orderDetail = orderDetail;
        self.bootomView.orderDetail = orderDetail;
        [self.baseTableView reloadData];
        self.baseTableView.tableHeaderView = self.headerView;

        if (self.bootomView.isShow) {
            self.bootomView.hidden = NO;
            [self.baseTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(-45);
            }];
        }else{
            self.bootomView.hidden = YES;
            [self.baseTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view);
            }];
        }
        
        [self closeTimer];
        if (orderDetail.car.carType == 1 && orderDetail.status == CarOrderStatusZFDJ ) {
            [self.headerView updateTimeDown:[self getNewCarAutoTime]];
        }
        if (orderDetail.status == CarOrderStatusZFWK || orderDetail.status == CarOrderStatusYFH ) {
            [self.headerView updateTimeDown:[self getCarOrderAutoReceiveTime]];
        }
    }];

}

- (void)setupView
{
    [self.baseTableView registerClass:[GGCarOrderBaseInfoCell class] forCellReuseIdentifier:kCellIdentifierCarOrderBaseInfo];
    [self.baseTableView registerClass:[GGNewCarOrderBaseInfoCell class] forCellReuseIdentifier:kGGNewCarOrderBaseInfoCellID];

    [self.baseTableView registerClass:[GGCarOrderPriceCell class] forCellReuseIdentifier:kCellIdentifierCarOrderPrice];
    [self.baseTableView registerClass:[GGCarOrderOtherInfoCell class] forCellReuseIdentifier:kCellIdentifierCarOrderOtherInfo];
    
    [self.view addSubview:self.bootomView];
    [self.bootomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    self.bootomView.hidden = YES;

    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self closeTimer];
    [super viewDidDisappear:animated];
}

#pragma mark - 自动计时功能

- (NSString *)getNewCarAutoTime
{
    if (self.carOrderVM.orderDetail) {
        if (!self.timer) {
            @weakify(self);
            self.timer = [NSTimer scheduledTimerWithTimeInterval:60 block:^(NSTimer * _Nonnull timer) {
                @strongify(self);
                if (self.carOrderVM.orderDetail) {
                    if (self.carOrderVM.orderDetail.xinCarGuaranteeDaysCountDown >= 60 * 1000) {
                        self.carOrderVM.orderDetail.xinCarGuaranteeDaysCountDown = self.carOrderVM.orderDetail.xinCarGuaranteeDaysCountDown - 60 * 1000;
                    }else{
                        [self.timer invalidate];
                    }
                    [self.headerView updateTimeDown:[self getNewCarAutoTime]];
                }
            } repeats:YES];
        }
        
        if (self.carOrderVM.orderDetail.xinCarGuaranteeDaysCountDown <= 0) {
            return @"即将自动关闭订单";
        }
        NSUInteger totalMinute =  self.carOrderVM.orderDetail.xinCarGuaranteeDaysCountDown / 60 / 1000;
        if (totalMinute < 1){
            return @"即将自动关闭订单";
        }else{
            NSString *timeString = [NSString stringWithFormat:@"%lu天%lu小时%lu分钟后订单自动关闭",(unsigned long)totalMinute/60/24,(unsigned long)totalMinute / 60 % 24,(unsigned long)totalMinute % 60];
            return timeString;
        }
    }
    return nil;
}

- (NSString *)getCarOrderAutoReceiveTime
{
    if (self.carOrderVM.orderDetail) {
        if (!self.timer) {
            @weakify(self);
            self.timer = [NSTimer scheduledTimerWithTimeInterval:60 block:^(NSTimer * _Nonnull timer) {
                @strongify(self);
                if (self.carOrderVM.orderDetail) {
                    if (self.carOrderVM.orderDetail.carAutoSureReceiveCountDown >= 60 * 1000) {
                        self.carOrderVM.orderDetail.carAutoSureReceiveCountDown = self.carOrderVM.orderDetail.carAutoSureReceiveCountDown - 60 * 1000;
                    }else{
                        [self.timer invalidate];
                    }
                }
                [self.headerView updateTimeDown:[self getCarOrderAutoReceiveTime]];
            } repeats:YES];
        }
        if (self.carOrderVM.orderDetail.carAutoSureReceiveCountDown <= 0) {
            return @"即将自动收货";
        }
        NSUInteger totalMinute =  self.carOrderVM.orderDetail.carAutoSureReceiveCountDown / 60 / 1000;
        if (totalMinute < 1){
            return @"即将自动收货";
        }else{
            NSString *timeString = [NSString stringWithFormat:@"%lu天%lu小时%lu分钟后自动收货",(unsigned long)totalMinute/60/24,(unsigned long)totalMinute / 60 % 24,(unsigned long)totalMinute % 60];
            return timeString;
        }
    }
    return nil;
}

- (void)closeTimer
{
    if (self.timer) {
        if (self.timer.isValid) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.carOrderVM.orderDetail.car.carType == 1) {
            GGNewCarOrderBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kGGNewCarOrderBaseInfoCellID];
            @weakify(self);
            [cell updateUIWithOrderModel:self.carOrderVM.orderDetail andCarInfoClicked:^(GGCarOrderDetail *orderDetail) {
                @strongify(self);
                [self goToCarInfoViewController:orderDetail];
            }];
            return cell;
        }else{
            GGCarOrderBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCarOrderBaseInfo];
            @weakify(self);
            [cell updateUIWithOrderModel:self.carOrderVM.orderDetail andCarInfoClicked:^(GGCarOrderDetail *orderDetail) {
                @strongify(self);
                [self goToCarInfoViewController:orderDetail];
            }];
            return cell;
        }
        
    }else if (indexPath.section == 1){
        GGCarOrderPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCarOrderPrice];
        cell.orderDetail = self.carOrderVM.orderDetail;
        return cell;
    }else{
        GGCarOrderOtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCarOrderOtherInfo];
        cell.orderDetail = self.carOrderVM.orderDetail;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:14 hasSectionLine:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if (self.carOrderVM.orderDetail.car.carType == 1) {
                return 258;
            }
            return 224;
        }
            break;
            
        case 1:
            return 70;
            break;
            
        default:{
            
            @weakify(self);
            CGFloat cellHeight =  [tableView fd_heightForCellWithIdentifier:kCellIdentifierCarOrderOtherInfo configuration:^(GGCarOrderOtherInfoCell *cell) {
                @strongify(self);
                cell.orderDetail = self.carOrderVM.orderDetail;
            }];
            return cellHeight;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12;
}

#pragma mark - Go to Car info VC

- (void)goToCarInfoViewController:(GGCarOrderDetail *)orderDetail
{
    if (orderDetail.car.carType == 1) {
        GGNewCarListModel *listModel = [[GGNewCarListModel alloc] init];
        listModel.carId = [orderDetail.car.xinCarId stringValue];
        GGNewCarDetailViewController *detailsVC = [[GGNewCarDetailViewController alloc] initWithListModel:listModel];
        [self pushTo:detailsVC];
    }else{
        GGVehicleList *vehicleList = [[GGVehicleList alloc] init];
        vehicleList.carId = orderDetail.car.carId;
        GGVehicleDetailsViewController *detailsVC = [[GGVehicleDetailsViewController alloc] initWithItem:vehicleList];
        [self pushTo:detailsVC];
    }
}

#pragma mark - Go to Pay VC

- (void)carOrderDetailButtonClicked:(UIButton *)sender{
    GGTransferAccountViewModel *accountVM = [[GGTransferAccountViewModel alloc] init];
    accountVM.account.realName = self.carOrderVM.orderDetail.saleName;
    accountVM.account.mobile = self.carOrderVM.orderDetail.car.user.mobile;
    accountVM.account.userId = self.carOrderVM.orderDetail.car.user.userId;
    accountVM.trade.orderNo = self.carOrderVM.orderDetail.orderNo;
    accountVM.goodsType = GoodsTypeCar;
    
    @weakify(self);
    if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"确认收货"]) {
        [self.codeView show];
    }else if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"修改价格"]){
        GGModifyPriceViewController *modifyVC = [[GGModifyPriceViewController alloc] init];
        modifyVC.value = RACTuplePack(self.carOrderVM.orderDetail.dealPrice,self.carOrderVM.orderDetail.orderNo);
        [modifyVC setPopHandler:^(NSNumber *value) {
            [self refreshingData];
        }];
        [self pushTo:modifyVC];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"申请退款"]){
    
        GGRefundmentViewController *refundVC = [[GGRefundmentViewController alloc] initWithCarOrderObject:self.carOrderVM.orderDetail];
        [refundVC setPopHandler:^(id obj) {
            [self pop];
            if (self.popHandler) {
                self.popHandler(@"刷新GGCarsOrderListViewController");
            }
        }];
        [GGCarOrderDetailViewController presentVC:refundVC];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"取消代付"]){
        [UIAlertController alertInController:self title:@"确定取消代付？" message:nil confrimBtn:@"确认" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
            [[self.otherPayVM.cancelApplyCommand execute:self.carOrderVM.orderDetail.payAnotherId] subscribeCompleted:^{
                @strongify(self);
                [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
                [self refreshingData];
            }];
        } cancelBtn:@"取消" cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
    } else{
        if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"支付订金"]) {
            accountVM.payType = PaymentTypeFDJ;
            accountVM.trade.tranAmount = self.carOrderVM.orderDetail.reservePrice;
            accountVM.trade.tranAmount = [NSString stringWithFormat:@"%@",self.carOrderVM.orderDetail.reservePrice];
        }else if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"支付尾款"]){
            accountVM.payType = PaymentTypeFWK;
            accountVM.trade.tranAmount = [NSString stringWithFormat:@"%@",self.carOrderVM.orderDetail.finalPrice];
        }
    

        GGTransferDetailViewController *transferDetailVC = [[GGTransferDetailViewController alloc] initWithObject:accountVM];
        [transferDetailVC setPopHandler:^(NSNumber *value){
            if(value.boolValue){
                [self refreshingData];
            }
        }];
        [[self class] presentVC:transferDetailVC];
        
    }
}

- (void)refreshingData
{
    [self.carOrderVM.orderDetailCommand execute:nil];
    if (self.popHandler) {
        self.popHandler(@"刷新GGCarsOrderListViewController");
    }
}

#pragma mark - GGPaymentCodeDelegate

- (void)didTappedConfirmButtonWithpaymentPassword:(NSString *)paymentPassword{
    
    [self.codeView dismiss];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [[self.carOrderVM.confirmGoodsCommand execute:paymentPassword] subscribeError:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } completed:^{
        @strongify(self);
        [self refreshingData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"收货成功" toView:self.view];
    }];
}

- (void)didTappedColseButton
{
    
}

- (void)didTappedForgetPasswordButton{
    GGCheckCardIDViewController *setPayPassVC = [[GGCheckCardIDViewController alloc] init];
    [[self class] presentVC:setPayPassVC];
}

- (void)paymentComplete{
    
}

#pragma mark - init views

- (GGCarOrderProgressView *)headerView{
    if (!_headerView) {
        _headerView = [[GGCarOrderProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 120)];
    }
    return _headerView;
}

- (GGCarOrderBottomView *)bootomView{
    if (!_bootomView) {
        _bootomView = [[GGCarOrderBottomView alloc] init];
        _bootomView.delegate  = self;
    }
    return _bootomView;
}

- (GGPaymentCodeView *)codeView
{
    if (!_codeView) {
        _codeView = [[GGPaymentCodeView alloc]init];
        _codeView.delegate = self;
    }
    return _codeView;
}

#pragma mark - init VM


- (GGCarOrderViewModel *)carOrderVM
{
    if (!_carOrderVM) {
        _carOrderVM = [[GGCarOrderViewModel alloc] init];
    }
    return _carOrderVM;
}

- (GGOtherPayDetailViewModel *)otherPayVM
{
    if (!_otherPayVM) {
        _otherPayVM = [[GGOtherPayDetailViewModel alloc] init];
    }
    return _otherPayVM;
}


@end

