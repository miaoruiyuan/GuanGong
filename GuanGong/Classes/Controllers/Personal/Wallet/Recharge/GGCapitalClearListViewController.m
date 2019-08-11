
//
//  GGCapitalClearListViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCapitalClearListViewController.h"
#import "GGCClearDetailViewController.h"
#import "GGCapitalClearViewModel.h"
#import "GGCapitalClearListCell.h"

@interface GGCapitalClearListViewController ()

@property(nonatomic,strong)GGCapitalClearViewModel *capitalClearVM;
@end

@implementation GGCapitalClearListViewController

- (void)bindViewModel{
    
}

- (void)setupView{
    self.navigationItem.title = @"申请记录";
    
    self.baseTableView.sectionHeaderHeight = 10;
    self.baseTableView.sectionFooterHeight = 0.01;
    self.baseTableView.rowHeight = 62;
    [self.baseTableView registerClass:[GGCapitalClearListCell class] forCellReuseIdentifier:kCellIdentifierCaptialClear];
    self.emptyDataTitle = @"暂无清分申请";
    self.enabledRefreshHeader = YES;
    self.enabledRefreshFooter = YES;
    
    [self beginHeaderRefreshing];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"car_ordey_list_empt_icon"];
}

- (void)refreshHeaderAction{
    if (self.capitalClearVM.isLoading) {
        return;
    }
    self.capitalClearVM.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshFooterAction{
    if (self.capitalClearVM.isLoading || !self.capitalClearVM.canLoadMore) {
        [self footerEndNoMoreData];
        return;
    }
    self.capitalClearVM.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest{
    
    [[self.capitalClearVM.loadData execute:nil]subscribeError:^(NSError *error) {
        [self endRefreshHeader];
        [self endRefreshFooter];
    } completed:^{
        [self endRefreshHeader];
        [self endRefreshFooter];
        
        [self.baseTableView reloadData];
    }];
    
    
    [[self.capitalClearVM.loadData.executing skip:1]subscribeNext:^(NSNumber *x) {
        self.emptyDataDisplay = !x.boolValue;
    }];
    
    
}



#pragma marl - Tb
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.capitalClearVM.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGCapitalClearListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCaptialClear];
    cell.clearList = self.capitalClearVM.dataSource[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kLeftPadding hasSectionLine:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GGCapitalClearList *item = self.capitalClearVM.dataSource[indexPath.section];
    GGCClearDetailViewController *vc = [[GGCClearDetailViewController alloc] initWithObject:item];
    [self pushTo:vc];
}


- (GGCapitalClearViewModel *)capitalClearVM{
    if (!_capitalClearVM) {
        _capitalClearVM = [[GGCapitalClearViewModel alloc] init];
    }
    return _capitalClearVM;
}




@end
