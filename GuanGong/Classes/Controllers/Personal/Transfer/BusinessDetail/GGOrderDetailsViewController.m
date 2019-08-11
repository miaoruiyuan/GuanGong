//
//  GGPaymentOrderDetailsViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOrderDetailsViewController.h"
#import "GGUploadDealInfoViewController.h"
#import "GGCheckCardIDViewController.h"
#import "GGFriendInfoViewController.h"
#import "GGTransferViewController.h"
#import "GGRefundmentViewController.h"

#import "GGTitleDisclosureCell.h"
#import "GGGoodsInfoCell.h"
#import "GGOrderRecordsCell.h"
#import "GGOrderInfoCell.h"
#import "GGOrderStateCell.h"

#import "GGTwoButtonsView.h"
#import "GGPaymentCodeView.h"

#import "GGOrderDetailViewModel.h"


@interface GGOrderDetailsViewController ()<ButtonViewDelegate,GGPaymentCodeDelegate>{
}
@property(nonatomic,strong)GGOrderDetailViewModel *detailVM;

@property(nonatomic,strong)GGOrderList *orderList;
@property(nonatomic,strong)GGTwoButtonsView *bottomView;
@property(nonatomic,strong)GGPaymentCodeView *codeView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger sectionCount;


@end

@implementation GGOrderDetailsViewController

- (instancetype)initWithObject:(GGOrderList *)obj{
    if (self = [super init]) {
        
        self.orderList = obj;
        self.detailVM.orderNo = obj.orderNo;
    
    }
    return self;
}

#pragma mark - 自动计时功能

- (NSString *)getAutoReceiveTime
{
    if (self.detailVM.orderDetail.isAutoSureReceive) {
        if (!self.timer) {
            @weakify(self);
            self.timer = [NSTimer scheduledTimerWithTimeInterval:60 block:^(NSTimer * _Nonnull timer) {
                @strongify(self);
                if (self.detailVM.orderDetail.isAutoSureReceive) {
                    if (self.detailVM.orderDetail.autoSureReceiveCountDown >= 60 * 1000) {
                        self.detailVM.orderDetail.autoSureReceiveCountDown = self.detailVM.orderDetail.autoSureReceiveCountDown - 60 * 1000;
                    }else{
                        [self.timer invalidate];
                    }
                }
                [self.baseTableView reloadData];
            } repeats:YES];
        }
        NSUInteger totalMinute =  self.detailVM.orderDetail.autoSureReceiveCountDown / 60 / 1000;
        if (totalMinute < 1){
            return @"即将自动收货";
        }else{
            NSString *timeString = [NSString stringWithFormat:@"%lu天%lu小时%lu分钟后自动收货",(unsigned long)totalMinute/60/24,(unsigned long)totalMinute / 60 % 24,(unsigned long)totalMinute % 60];
            return timeString;
        }
    }
    return nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.timer) {
        if (self.timer.isValid) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
    [super viewDidDisappear:animated];
}

- (void)bindViewModel{
    @weakify(self);
    [[[RACObserve(self.detailVM, orderDetail) skip:1] deliverOnMainThread]subscribeNext:^(GGOrderDetails *x) {
        @strongify(self);
        self.sectionCount = 4;

        if (self.orderList.isBuyer) {
             _bottomView = [[GGTwoButtonsView alloc] initWithBuyerDetailObj:x isRefundDetail:NO];
        }else{
             _bottomView = [[GGTwoButtonsView alloc] initWithSellerDetailObj:x isRefundDetail:NO];
        }
        
        _bottomView.delegate = self;
        
        [self.view addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.height.mas_equalTo(44);
        }];
        
        [self.baseTableView reloadData];
    }];
    
    [self.detailVM.detailDataCommand execute:@1];
    [[self.detailVM.detailDataCommand.executing skip:1]subscribeNext:^(NSNumber *x) {
        if ([x isEqualToNumber:@YES]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
}

- (void)setupView
{
    self.navigationItem.title = @"订单详情";
    self.baseTableView.sectionFooterHeight = 0.01;
    self.baseTableView.sectionHeaderHeight = 12;
    [self.baseTableView registerClass:[GGTitleDisclosureCell class] forCellReuseIdentifier:kCellIdentifierTitleDisclosure];
    [self.baseTableView registerClass:[GGGoodsInfoCell class] forCellReuseIdentifier:kCellIdentifierGoodsInfo];
    [self.baseTableView registerClass:[GGOrderRecordsCell class] forCellReuseIdentifier:kCellIdentifierOrderRecord];
    [self.baseTableView registerClass:[GGOrderInfoCell class] forCellReuseIdentifier:kCellIdentifierOrderInfo];
    [self.baseTableView registerClass:[GGOrderStateCell class] forCellReuseIdentifier:kCellIdentifierOrderState];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionCount;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 2;
            break;
            
        case 2:
            return self.detailVM.orderDetail.orderRecords.count;
            break;
            
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GGOrderStateCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierOrderState];
        
        [cell updateUIWithModel:self.orderList andReceiptTime:[self getAutoReceiveTime]];
        
        return cell;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            GGTitleDisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTitleDisclosure];
            [cell setTitleStr:[NSString stringWithFormat:@"%@%@",self.orderList.isBuyer ? @"卖家: ":@"买家: ",self.orderList.dealerRealName]];
            return cell;

        }else{
            GGGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierGoodsInfo];
            cell.goodInfo = self.detailVM.orderDetail.goodsInfo;
            return cell;
        }
        
    }else if (indexPath.section == 2){
        GGOrderRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierOrderRecord];
        cell.orderRecords = self.detailVM.orderDetail.orderRecords[indexPath.row];
        return cell;
    }else{
        GGOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierOrderInfo];
        cell.orderDetails = self.detailVM.orderDetail;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kLeftPadding hasSectionLine:NO];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
            return 50;
            break;
            
        case 1:{
            if (indexPath.row == 0) {
                return 48;
            }else{
                return [tableView fd_heightForCellWithIdentifier:kCellIdentifierGoodsInfo cacheByIndexPath:indexPath configuration:^(GGGoodsInfoCell *cell) {
                    cell.goodInfo = self.detailVM.orderDetail.goodsInfo;
                }];
            }

        }
            break;
            
        case 2:{
            return [tableView fd_heightForCellWithIdentifier:kCellIdentifierOrderRecord cacheByIndexPath:indexPath configuration:^(GGOrderRecordsCell *cell) {
                cell.orderRecords = self.detailVM.orderDetail.orderRecords[indexPath.row];
            }];
        }
            break;
            
            
        default:
            return 58;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (indexPath.section == 1 && indexPath.row == 0) {
        GGFriendInfoViewController *friendInfoVC = [[GGFriendInfoViewController alloc] init];
        friendInfoVC.dealerId = self.orderList.dealerId;
        [self pushTo:friendInfoVC];
    }
}

#pragma mark - TwoButtonViewDelegate
- (void)twoButtonClicked:(UIButton *)sender
{
    if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"上传交易信息"] || [[sender titleForState:UIControlStateNormal]isEqualToString:@"修改交易信息"]) {
        GGUploadDealInfoViewController *uploadVC = [[GGUploadDealInfoViewController alloc]init];
        uploadVC.orderNo = self.orderList.orderNo;
        [uploadVC setPopHandler:^(id obj) {
            [self.detailVM.detailDataCommand execute:@1];
        }];
        [GGOrderDetailsViewController presentVC:uploadVC];
        [MobClick event:@"submitdeal"];
    }else if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"确认收货"]){
        
        NSString *title = self.orderList.hasApplyReturn ? @"此交易已提交退款申请,确认收货将关闭退款":@"请确保收到货物并满意后再确认收货";
        
        [UIAlertController alertInController:self
                                       title:title
                                     message:nil
                                  confrimBtn:@"确认收货"
                                confrimStyle:UIAlertActionStyleDefault
                               confrimAction:^{
                                   [self.codeView show];
                               }
                                   cancelBtn:@"取消"
                                 cancelStyle:UIAlertActionStyleCancel
                                cancelAction:^{
                                    
                                }];
        
        [MobClick event:@"detail_confirmreceipt"];

    }else if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"支付尾款"]){
        
        GGAccount *account = [[GGAccount alloc]init];
        account.realName = self.orderList.dealerName;
        account.mobile = self.orderList.dealerMobile;
        account.userId = self.orderList.dealerId;
        account.icon = self.orderList.dealerIcon;
        
        GGTransferViewController *transferVC = [[GGTransferViewController alloc] initWithItem:account];
        transferVC.transferVM.isTransfer = NO;
        transferVC.transferVM.isFinalPay = YES;
        transferVC.transferVM.trade.orderNo = self.orderList.orderNo;

        
        if (self.detailVM.orderDetail.statusId == OrderStatusTypeTHTK || self.detailVM.orderDetail.statusId == OrderStatusTypeJJTK) {
            [UIAlertController alertInController:self
                                           title:@"此交易已提交退款申请，成功支付尾款后将关闭退款。"
                                         message:nil confrimBtn:@"确定支付"
                                    confrimStyle:UIAlertActionStyleDefault
                                   confrimAction:^{
                                       [self pushTo:transferVC];
                                   }
                                       cancelBtn:@"取消"
                                     cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
        }else{
            [self pushTo:transferVC];
        }
        [MobClick event:@"detail_finalpayment"];
    }else if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"申请退款"]){
        GGRefundmentViewController *refundVC = [[GGRefundmentViewController alloc] initWithObject:self.detailVM.orderDetail];
        [refundVC setPopHandler:^(id obj) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GGRefreshBuyerListNotification object:nil];
            [self pop];
        }];
        [GGOrderDetailsViewController presentVC:refundVC];
        [MobClick event:@"detail_refund"];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark -GGPaymentCodeDelegate
- (void)didTappedConfirmButtonWithpaymentPassword:(NSString *)paymentPassword{
    
    [self.codeView dismiss];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    

    [[self.detailVM.confirmGoodsCommand execute:paymentPassword]subscribeError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } completed:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"收货成功" toView:self.view];
        
        [self bk_performBlock:^(GGOrderDetailsViewController *obj) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GGRefreshBuyerListNotification object:nil];
            [obj pop];
        } afterDelay:1.0];
        
    }];
}
- (void)didTappedColseButton{
    
}
- (void)didTappedForgetPasswordButton{
    GGCheckCardIDViewController *setPayPassVC = [[GGCheckCardIDViewController alloc] init];
    [[self class] presentVC:setPayPassVC];
}
- (void)paymentComplete{
    
}


- (GGOrderDetailViewModel *)detailVM{
    if (!_detailVM) {
        _detailVM = [[GGOrderDetailViewModel alloc] init];
    }
    return _detailVM;
}

- (GGPaymentCodeView *)codeView{
    if (!_codeView) {
        _codeView = [[GGPaymentCodeView alloc]init];
        _codeView.delegate = self;
    }
    return _codeView;
}


@end
