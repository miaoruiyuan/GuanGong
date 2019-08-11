//
//  GGRefundDetailsViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/12.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGRefundDetailsViewController.h"
#import "GGRefuseRefundViewController.h"
#import "GGSetPayPasswordViewController.h"
#import "GGRefundmentViewController.h"
#import "GGRefundDescribeCell.h"
#import "GGUploadDealInfoViewModel.h"
#import "GGOrderDetailViewModel.h"
#import "GGTwoButtonsView.h"
#import "GGPaymentCodeView.h"

@interface GGRefundDetailsViewController ()<ButtonViewDelegate,GGPaymentCodeDelegate>

@property(nonatomic,strong)GGTwoButtonsView *bottomView;

@property(nonatomic,strong)GGPaymentCodeView *codeView;

@property(nonatomic,strong)GGOrderList *orderList;

@property(nonatomic,strong)GGOrderDetailViewModel *detailVM;

@property(nonatomic,strong)GGUploadDealInfoViewModel *dealInfoVM;

@end

@implementation GGRefundDetailsViewController{
    BOOL isConfirmGoods;
}

- (id)initWithObject:(GGOrderList *)obj{
    if (self = [super init]) {
        self.orderList = obj;
        self.detailVM.orderNo = obj.orderNo;
    }
    return self;
}


- (void)bindViewModel{
 
    [self.detailVM.detailDataCommand execute:@4];
    [[self.detailVM.detailDataCommand.executing skip:1]subscribeNext:^(NSNumber *x) {
        if ([x isEqualToNumber:@YES]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];

    [RACObserve(self.detailVM,orderDetail) subscribeNext:^(GGOrderDetails *orderDetails) {
        
        if (_bottomView) {
            [_bottomView removeFromSuperview];
        }
        
        if (self.orderList.isBuyer) {
            _bottomView = [[GGTwoButtonsView alloc] initWithBuyerDetailObj:orderDetails isRefundDetail:YES];
        }else{
            _bottomView = [[GGTwoButtonsView alloc] initWithSellerDetailObj:orderDetails isRefundDetail:YES];
        }
        _bottomView.delegate = self;
        
        [self.view addSubview:_bottomView];
        [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(44);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-64);
        }];

        [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self.view);
            make.bottom.equalTo(_bottomView.mas_top);
        }];
        
        
        [self.baseTableView reloadData];
    }];
}

- (void)setupView
{
    self.navigationItem.title = @"退款详情";
    self.view.backgroundColor = tableBgColor;
    [self.baseTableView registerClass:[GGRefundDescribeCell class] forCellReuseIdentifier:kCellIdentifierRefundDescribe];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}


#pragma mark -UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailVM.orderDetail.orderRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGRefundDescribeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierRefundDescribe];
    cell.records = self.detailVM.orderDetail.orderRecords[indexPath.row];;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark -ButtonViewDelegate
- (void)twoButtonClicked:(UIButton *)sender
{
     if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"收到退货"]) {
        [UIAlertController alertInController:self
                                       title:@"请确保收到买家的退货后再确认收货"
                                     message:nil
                                  confrimBtn:@"确认"
                                confrimStyle:UIAlertActionStyleDefault
                               confrimAction:^{
                                   isConfirmGoods = YES;
                                   [self.codeView show];
                               }
                                   cancelBtn:@"取消"
                                 cancelStyle:UIAlertActionStyleCancel
                                cancelAction:nil];
    }else if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"拒绝退款"]){
        GGRefuseRefundViewController *refuseVC = [[GGRefuseRefundViewController alloc]init];
        refuseVC.orderNo = _orderList.orderNo;
        [refuseVC setPopHandler:^(id obj) {
            [self.detailVM.detailDataCommand execute:@4];
        }];
        [GGRefundDetailsViewController presentVC:refuseVC];
        [MobClick event:@"refuserefund"];
    }else if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"同意退款"]){
        
        NSString *title = @"";
        if (_orderList.statusId == OrderStatusTypeSQTK) {
           title = @"同意退款后,退款金额将返回到买家账户";
        }else if (_orderList.statusId == OrderStatusTypeTHTK){
            title = @"同意退货后,买家将退还商品给卖家";
        }
        
        [UIAlertController alertInController:self
                                       title:title
                                     message:nil
                                  confrimBtn:@"确认"
                                confrimStyle:UIAlertActionStyleDefault
                               confrimAction:^{
                                   isConfirmGoods = NO;
                                   [self.codeView show];
                               }
                                   cancelBtn:@"取消"
                                 cancelStyle:UIAlertActionStyleCancel
                                cancelAction:nil];
        [MobClick event:@"agreerefund"];
    }else if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"确认收货"]){
        
        [UIAlertController alertInController:self
                                       title:@"请确保收到买家的退货后再确认收货"
                                     message:nil
                                  confrimBtn:@"确认收货"
                                confrimStyle:UIAlertActionStyleDefault
                               confrimAction:^{
                                   isConfirmGoods = YES;
                                   [self.codeView show];
                               }
                                   cancelBtn:@"取消"
                                 cancelStyle:UIAlertActionStyleCancel
                                cancelAction:nil];
        [MobClick event:@"detail_confirmreceipt"];
    }else if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"修改申请"]){
        
        GGRefundmentViewController *refundVC = [[GGRefundmentViewController alloc] initWithObject:self.detailVM.orderDetail];
        [refundVC setPopHandler:^(id obj) {
           [self.detailVM.detailDataCommand execute:@4];
        }];
        [GGRefundDetailsViewController presentVC:refundVC];
        [MobClick event:@"modifyrefund"];
    }
}


#pragma mark -GGPaymentCodeDelegate
- (void)didTappedConfirmButtonWithpaymentPassword:(NSString *)paymentPassword{
    
    [self.codeView dismiss];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (isConfirmGoods) {

        [[self.detailVM.sellerConfirmGoodsCommand execute:paymentPassword] subscribeError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } completed:^{
            [self.detailVM.detailDataCommand execute:@4];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"收货成功" toView:self.view];
        }];
    
    }else{
        
        self.dealInfoVM.password = paymentPassword;
        self.dealInfoVM.isAgree = YES;
        
        [[self.dealInfoVM.submitRefuseCommand execute:self.orderList.orderNo]subscribeError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } completed:^{
            [self.detailVM.detailDataCommand execute:@4];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"已同意退款" toView:self.view];
        }];

    }
}

- (void)didTappedColseButton{
    
}

- (void)didTappedForgetPasswordButton{
    GGSetPayPasswordViewController *setPayPassVC = [[GGSetPayPasswordViewController alloc] init];
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

- (GGUploadDealInfoViewModel *)dealInfoVM{
    if (!_dealInfoVM) {
        _dealInfoVM = [[GGUploadDealInfoViewModel alloc] init];
    }
    return _dealInfoVM;
}


- (GGPaymentCodeView *)codeView{
    if (!_codeView) {
        _codeView = [[GGPaymentCodeView alloc]init];
        _codeView.delegate = self;
    }
    return _codeView;
}

@end
