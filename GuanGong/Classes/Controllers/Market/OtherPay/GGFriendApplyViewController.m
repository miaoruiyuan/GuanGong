//
//  GGFriendApplyViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFriendApplyViewController.h"
#import "GGOtherPayDetailViewController.h"
#import "GGOtherPayCell.h"

@interface GGFriendApplyViewController ()

@property(nonatomic,assign)BOOL isMineApply;

@end

@implementation GGFriendApplyViewController

- (void)bindViewModel{    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:GGOtherPayListNotification object:nil]subscribeNext:^(id x) {
      
        [self sendRequest];
    }];
    
    self.isMineApply = NO;
}

- (void)setupView{
    
    self.baseTableView.rowHeight = 75;
    self.baseTableView.sectionFooterHeight = 0.01;
    self.baseTableView.sectionHeaderHeight = 12;
    [self.baseTableView registerClass:[GGOtherPayCell class] forCellReuseIdentifier:kCellIdentifierOtherPay];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    self.emptyDataTitle = @"暂无申请记录";
    self.enabledRefreshHeader = YES;
    self.enabledRefreshFooter = YES;
    
    [self beginHeaderRefreshing];
}

- (void)refreshHeaderAction{
    if (self.otherPayVM.isLoading) {
        return;
    }
    self.otherPayVM.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshFooterAction{
    if (self.otherPayVM.isLoading || !self.otherPayVM.canLoadMore) {
        [self footerEndNoMoreData];
        return;
    }
    self.otherPayVM.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest
{
    [[self.otherPayVM.loadData execute:@2]subscribeError:^(NSError *error) {
        [self endRefreshHeader];
        [self endRefreshFooter];
    } completed:^{
        [self endRefreshHeader];
        [self endRefreshFooter];
        [self.baseTableView reloadData];
    }];

    [[self.otherPayVM.loadData.executing skip:1] subscribeNext:^(NSNumber *x) {
        self.emptyDataDisplay = !x.boolValue;
    }];

}

#pragma mark - TB
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = self.otherPayVM.dataSource.count;
    tableView.mj_footer.hidden = count > 6 ? NO : YES;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGOtherPayList *item = self.otherPayVM.dataSource[indexPath.section];
    GGOtherPayCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierOtherPay];
    cell.isMineApply = self.isMineApply;
    cell.otherPayList = item;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GGOtherPayList *item = self.otherPayVM.dataSource[indexPath.section];
    GGOtherPayDetailViewController *payDetailVC = [[GGOtherPayDetailViewController alloc] init];
    payDetailVC.applyId = item.applyId;
    payDetailVC.isMineApply = self.isMineApply;
    [self pushTo:payDetailVC];
}


- (GGOtherPayViewModel *)otherPayVM{
    if (!_otherPayVM) {
        _otherPayVM = [[GGOtherPayViewModel alloc] init];
    }
    return _otherPayVM;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GGOtherPayListNotification object:nil];
}

@end
