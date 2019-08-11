//
//  GGCheckOrderListViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckOrderListViewController.h"
#import "GGCheckOrderDetailViewController.h"
#import "GGCheckOrderListCell.h"

@interface GGCheckOrderListViewController ()

@property(nonatomic,strong)GGCheckOrderViewModel *checkOrderVM;

@end

@implementation GGCheckOrderListViewController

- (void)bindViewModel{
    @weakify(self);
    [[self.checkOrderVM.loadData.executing skip:1]subscribeNext:^(NSNumber *x) {
        @strongify(self);
         self.emptyDataDisplay = !x.boolValue;
    }];
    
}

- (void)setupView
{
    self.baseTableView.sectionHeaderHeight = 10;
    self.baseTableView.sectionFooterHeight = 0.01;
    self.baseTableView.rowHeight = 80;
    [self.baseTableView registerClass:[GGCheckOrderListCell class] forCellReuseIdentifier:kCellIdentifierCheckOrder];
    self.emptyDataTitle = @"暂无质检订单";
    self.enabledRefreshHeader = YES;
    self.enabledRefreshFooter = YES;
    
    [self beginHeaderRefreshing];
    
}

- (void)refreshHeaderAction
{
    if (self.checkOrderVM.isLoading) {
        return;
    }
    self.checkOrderVM.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshFooterAction{
    if (self.checkOrderVM.isLoading || !self.checkOrderVM.canLoadMore) {
        [self footerEndNoMoreData];
        return;
    }
    self.checkOrderVM.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest{
    
    [[self.checkOrderVM.loadData execute:@(self.orderStatus)]subscribeError:^(NSError *error) {
        [self endRefreshHeader];
        [self endRefreshFooter];
    } completed:^{
        [self endRefreshHeader];
        [self endRefreshFooter];
        
        [self.baseTableView reloadData];
    }];
    
}



#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = self.checkOrderVM.dataSource.count;
    tableView.mj_footer.hidden = count > 6 ? NO : YES;
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGCheckOrderList *item = self.checkOrderVM.dataSource[indexPath.section];
    GGCheckOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCheckOrder];
    cell.orderList = item;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GGCheckOrderList *item = self.checkOrderVM.dataSource[indexPath.section];
    
    GGCheckOrderDetailViewController *detailVC = [[GGCheckOrderDetailViewController alloc] init];
    detailVC.orderId = item.orderId;
    [self pushTo:detailVC];
   

}


- (GGCheckOrderViewModel *)checkOrderVM{
    if (!_checkOrderVM) {
        _checkOrderVM = [[GGCheckOrderViewModel alloc] init];
    }
    return _checkOrderVM;
}

@end
