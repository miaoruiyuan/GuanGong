//
//  GGBillingDetailsViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBillingDetailsViewController.h"
#import "GGBillDetailPriceCell.h"
#import "GGBillDetailDealerCell.h"
#import "GGBillDetailInfoCell.h"
#import "GGBillDetailDateCell.h"
#import "GGFriendInfoViewController.h"
#import "GGBillDetailHeaderView.h"
#import "GGBillDetailViewModel.h"


@interface GGBillingDetailsViewController ()

@property(nonatomic,strong)GGBillDetailHeaderView *tableHeaderView;
@property(nonatomic,strong)GGBillDetailViewModel *detailVM;

@end

@implementation GGBillingDetailsViewController

- (void)bindViewModel
{
    [self.detailVM.detailDataCommand execute:self.item.payId];
    
    @weakify(self);
    [[RACObserve(self.detailVM, billInfo) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        self.tableHeaderView.info = x;
        [self.tableHeaderView.btnTapSinal subscribeNext:^(id x) {
            GGFriendInfoViewController *friendInfoVC = [[GGFriendInfoViewController alloc] init];
            friendInfoVC.dealerId = self.detailVM.billInfo.dealerId;
            [self pushTo:friendInfoVC];
        }];
    }];
}

- (void)setupView
{
    self.navigationItem.title = @"账单详情";
    self.baseTableView.tableHeaderView = self.tableHeaderView;
}

- (GGBillDetailViewModel *)detailVM{
    if (!_detailVM) {
        _detailVM = [[GGBillDetailViewModel alloc]init];
    }
    return _detailVM;
}

- (GGBillDetailHeaderView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[GGBillDetailHeaderView alloc] initWithImage:[UIImage imageNamed:@"bill_detail"]];
        _tableHeaderView.userInteractionEnabled = YES;
    }
    return _tableHeaderView;
}

@end
