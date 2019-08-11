//
//  GGCheckOrderDetailViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/9.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckOrderDetailViewController.h"
#import "GGWebViewController.h"
#import "GGCheckOrderDetailStateCell.h"
#import "GGCheckOrderDetailBaseInfoCell.h"
#import "GGCheckOrderList.h"
#import "GGTransferDetailViewController.h"

@interface GGCheckOrderDetailViewController ()

@property(nonatomic,strong)GGCheckOrderList *orderDetail;
@property(nonatomic,strong)UIButton *payButton;

@end

@implementation GGCheckOrderDetailViewController

- (void)bindViewModel{
    [self request];
    
    @weakify(self);
    [RACObserve(self, orderDetail)subscribeNext:^(id x) {
        @strongify(self);
        [self.baseTableView reloadData];
    }];
}

- (void)setupView
{
    self.navigationItem.title = @"订单详情";
    self.baseTableView.sectionHeaderHeight = 0.01;
    [self.baseTableView registerClass:[GGCheckOrderDetailStateCell class] forCellReuseIdentifier:kCellIdentifierCheckOrderState];
    [self.baseTableView registerClass:[GGCheckOrderDetailBaseInfoCell class] forCellReuseIdentifier:kCellIdentifierCheckOrderDetailBaseInfo];

    [self.view addSubview:self.payButton];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.height.mas_equalTo(42);
    }];
    
    @weakify(self);
    [[self.payButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        GGTransferAccountViewModel *accountVM = [[GGTransferAccountViewModel alloc] init];
        accountVM.isTransfer = YES;
        accountVM.goodsType = GoodsTypeCheckCar;
        accountVM.account.userId = self.orderDetail.saleId;
        accountVM.trade.tranAmount = self.orderDetail.price;
        accountVM.trade.orderNo = self.orderDetail.orderNo;
        accountVM.account.realName = self.orderDetail.checkServiceName;
        
        GGTransferDetailViewController *transferDetailVC = [[GGTransferDetailViewController alloc] initWithObject:accountVM];
        [transferDetailVC setPopHandler:^(NSNumber *value){
            if(value.boolValue){
                [self request];
            }
        }];
        [[self class] presentVC:transferDetailVC];
    }];
}

- (void)request
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [[GGApiManager request_checkCarOrderDetailWithOrderId:self.orderId] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.orderDetail = [GGCheckOrderList modelWithDictionary:x];
        self.payButton.hidden = self.orderDetail.orderStatus == CheckOrderStatusBePayment ? NO : YES;
    } error:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - Table
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GGCheckOrderDetailStateCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCheckOrderState];
        cell.orderStatus = self.orderDetail.orderStatus;
        return cell;
    }else{
        GGCheckOrderDetailBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCheckOrderDetailBaseInfo];
        cell.orderDetail = self.orderDetail;
        @weakify(self);
        [[[cell.reportButton rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(id x) {
            @strongify(self);
            if (self.orderDetail.checkReportUrl.length > 0) {
                GGWebViewController *webVC = [[GGWebViewController alloc] init];
                webVC.url = self.orderDetail.checkReportUrl;
                [GGCheckOrderDetailViewController presentVC:webVC];
            }else{
                [MBProgressHUD showError:@"质检报告生成中" toView:self.view];
            }

        }];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 46;
    }else{
        return 480;
    }
}




- (UIButton *)payButton{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"14b2e6"]]
                              forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        _payButton.layer.masksToBounds = YES;
        _payButton.layer.cornerRadius = 6;
        _payButton.hidden = YES;
    }
    return _payButton;
}


@end
