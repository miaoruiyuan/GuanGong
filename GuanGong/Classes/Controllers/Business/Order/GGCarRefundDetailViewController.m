//
//  GGCarRefundDetailViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/12/9.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarRefundDetailViewController.h"
#import "GGRefuseRefundViewController.h"
#import "GGRefundmentViewController.h"
#import "GGCheckCardIDViewController.h"
#import "GGCarOrderViewModel.h"
#import "GGUploadDealInfoViewModel.h"
#import "GGRefundDescribeCell.h"
#import "GGCarOrderBottomView.h"
#import "GGPaymentCodeView.h"


@interface GGCarRefundDetailViewController ()<CarOrderDetailButtonViewDelegate,GGPaymentCodeDelegate>

@property(nonatomic,strong)GGCarOrderViewModel *carOrderVM;
@property(nonatomic,strong)GGUploadDealInfoViewModel *dealInfoVM;
@property(nonatomic,strong)GGCarOrderBottomView *bottomView;
@property(nonatomic,strong)GGPaymentCodeView *codeView;

@end

@implementation GGCarRefundDetailViewController{
    BOOL isConfirmGoods;
}

- (id)initWithObject:(GGCarOrderDetail *)obj{
    if (self = [super init]) {
        self.carOrderVM.orderDetail = obj;
        self.bottomView.isRefund = YES;
    }
    return self;
}

- (void)bindViewModel{
    
    @weakify(self);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[self.carOrderVM.orderDetailCommand execute:nil]subscribeError:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } completed:^{
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

    [[RACObserve(self.carOrderVM, orderDetail) skip:1]subscribeNext:^(GGCarOrderDetail *x) {
        @strongify(self);
        self.bottomView.orderDetail = x;
        [self.baseTableView reloadData];
    }];
    
    //监听底部高度
    [[RACObserve(self.bottomView,height) skip:1] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        [self.view addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-64);
            make.height.mas_equalTo(x.floatValue);
        }];
        
        [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        
    }];
}

- (void)setupView{
    self.view.backgroundColor = tableBgColor;
    [self.baseTableView registerClass:[GGRefundDescribeCell class] forCellReuseIdentifier:kCellIdentifierRefundDescribe];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.carOrderVM.orderDetail.backOrderRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGRefundDescribeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierRefundDescribe];
    cell.carRecords = self.carOrderVM.orderDetail.backOrderRecords[indexPath.row];;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:kCellIdentifierRefundDescribe cacheByIndexPath:indexPath configuration:^(GGRefundDescribeCell *cell) {
        cell.carRecords = self.carOrderVM.orderDetail.backOrderRecords[indexPath.row];
    }];
}

#pragma Mark- CarOrderDetailButtonViewDelegate

- (void)carOrderDetailButtonClicked:(UIButton *)sender{

    @weakify(self);
    
    NSString *btnTitle = [sender titleForState:UIControlStateNormal];
    if ([btnTitle isEqualToString:@"拒绝退款"]){
        GGRefuseRefundViewController *refuseVC = [[GGRefuseRefundViewController alloc]init];
        refuseVC.orderNo = self.carOrderVM.orderDetail.orderNo;
        [refuseVC setPopHandler:^(id obj) {
            [self.carOrderVM.orderDetailCommand execute:nil];
        }];
        [GGCarRefundDetailViewController presentVC:refuseVC];
        
    }else if ([btnTitle isEqualToString:@"拒绝退货"]){
        GGRefuseRefundViewController *refuseVC = [[GGRefuseRefundViewController alloc]init];
        refuseVC.orderNo = self.carOrderVM.orderDetail.orderNo;
        [refuseVC setPopHandler:^(id obj) {
            [self.carOrderVM.orderDetailCommand execute:nil];
        }];
        [GGCarRefundDetailViewController presentVC:refuseVC];
    }else if ([btnTitle isEqualToString:@"同意退款"]){
        
        [UIAlertController alertInController:self
                                       title:@"同意退款后,退款金额将返回到买家账户"
                                     message:nil
                                  confrimBtn:@"确认"
                                confrimStyle:UIAlertActionStyleDefault
                               confrimAction:^{
                                   @strongify(self);
                                   isConfirmGoods = NO;
                                   [self.codeView show];
                               }
                                   cancelBtn:@"取消"
                                 cancelStyle:UIAlertActionStyleCancel
                                cancelAction:nil];
        
    }else if ([btnTitle isEqualToString:@"同意退货"]){
        
        [UIAlertController alertInController:self
                                       title:@"同意退货后,买家将退还商品给卖家"
                                     message:nil
                                  confrimBtn:@"确认"
                                confrimStyle:UIAlertActionStyleDefault
                               confrimAction:^{
                                   @strongify(self);
                                   isConfirmGoods = NO;
                                   [self.codeView show];
                               }
                                   cancelBtn:@"取消"
                                 cancelStyle:UIAlertActionStyleCancel
                                cancelAction:nil];
        
    }else if ([btnTitle isEqualToString:@"收到退货"]){
        
        [UIAlertController alertInController:self
                                       title:@"请确保收到买家的退货后再确认收货"
                                     message:nil
                                  confrimBtn:@"确认收货"
                                confrimStyle:UIAlertActionStyleDefault
                               confrimAction:^{
                                   @strongify(self);
                                   isConfirmGoods = YES;
                                   [self.codeView show];
                               }
                                   cancelBtn:@"取消"
                                 cancelStyle:UIAlertActionStyleCancel
                                cancelAction:nil];
        
        
    }else if ([btnTitle isEqualToString:@"修改申请"]){
        
        GGRefundmentViewController *refundVC = [[GGRefundmentViewController alloc] initWithCarOrderObject:self.carOrderVM.orderDetail];
        [refundVC setPopHandler:^(id obj) {
            [self pop];
        }];
        [GGCarRefundDetailViewController presentVC:refundVC];
    }
}


#pragma mark - GGPaymentCodeDelegate

- (void)didTappedConfirmButtonWithpaymentPassword:(NSString *)paymentPassword{
    [self.codeView dismiss];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    @weakify(self);
    if (isConfirmGoods) {
        
        [[self.carOrderVM.sellerConfirmGoodsCommand execute:paymentPassword] subscribeError:^(NSError *error) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } completed:^{
            @strongify(self);
            [self.carOrderVM.orderDetailCommand execute:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"收货成功" toView:self.view];
        }];
        
    }else{
        
        self.dealInfoVM.password = paymentPassword;
        self.dealInfoVM.isAgree = YES;
        
        [[self.dealInfoVM.submitRefuseCommand execute:self.carOrderVM.orderDetail.orderNo]subscribeError:^(NSError *error) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } completed:^{
            @strongify(self);
            [self.carOrderVM.orderDetailCommand execute:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"已同意退款" toView:self.view];
        }];
    }
}

- (void)didTappedForgetPasswordButton{
    
    GGCheckCardIDViewController *setPayPassVC = [[GGCheckCardIDViewController alloc] init];
    [[self class] presentVC:setPayPassVC];
}

- (void)didTappedColseButton{
    
}

- (void)paymentComplete{
    
}

#pragma mark - init View

- (GGCarOrderBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[GGCarOrderBottomView alloc] init];
        _bottomView.delegate  = self;
    }
    return _bottomView;
}

- (GGPaymentCodeView *)codeView{
    if (!_codeView) {
        _codeView = [[GGPaymentCodeView alloc]init];
        _codeView.delegate = self;
    }
    return _codeView;
}

#pragma mark - init VM

- (GGCarOrderViewModel *)carOrderVM{
    if (!_carOrderVM) {
        _carOrderVM = [[GGCarOrderViewModel alloc] init];
    }
    return _carOrderVM;
}

- (GGUploadDealInfoViewModel *)dealInfoVM{
    if (!_dealInfoVM) {
        _dealInfoVM = [[GGUploadDealInfoViewModel alloc] init];
    }
    return _dealInfoVM;
}

@end
