//
//  CWTVinHistoryViewController.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/21.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTVinHistoryViewController.h"
#import "CWTVinHistoryViewModel.h"
#import "CWTVinHistoryCell.h"
#import "GGCarHistroyDetailWebController.h"

@interface CWTVinHistoryViewController ()

@property(nonatomic,strong)CWTVinHistoryViewModel *historyVm;

@end

@implementation CWTVinHistoryViewController

- (void)setupView
{
    self.navigationItem.title = @"历史查询";
    self.emptyDataMessage = @"暂无历史记录";
    
    [self.baseTableView registerClass:[CWTVinHistoryCell class] forCellReuseIdentifier:kCellIdentifierVinHistoryCell];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.enabledRefreshHeader  = YES;
    self.enabledRefreshFooter = YES;
}

- (void)bindViewModel
{
    self.historyVm.serviceCompany = self.serviceCompany;
    @weakify(self);
    [RACObserve(self.historyVm, totalCount)subscribeNext:^(NSNumber *historyCount) {
        @strongify(self);
        if (historyCount.integerValue > 0) {
            self.navigationItem.title = [NSString stringWithFormat:@"历史查询 (%@)",historyCount];
        }
    }];
    
    [self beginHeaderRefreshing];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isMaintain) {
        [self refreshHeaderAction];
    }
}

#pragma mark - pull refresh

- (void)refreshHeaderAction{
    [self refresh];
}

- (void)refreshFooterAction{
    [self refreshMore];
}

- (void)refresh{
    if (self.historyVm.isLoading) {
        return;
    }
    self.historyVm.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshMore{
    if (self.historyVm.isLoading || !self.historyVm.canLoadMore) {
        [self footerEndNoMoreData];
        return;
    }
    self.historyVm.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest{
    @weakify(self);
    
    RACCommand *listCommand;
    if (self.isMaintain) {
        listCommand = self.historyVm.carHistoryListCommand;
    } else {
        listCommand = self.historyVm.vinInfoListCommand;
    }
    
    [[listCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.emptyDataDisplay = YES;
        [self.baseTableView reloadData];
        [self endRefreshHeader];
        [self endRefreshFooter];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = self.historyVm.dataSource.count;
    tableView.mj_footer.hidden = count > 6 ? NO : YES;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CWTVinHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierVinHistoryCell];
    if (self.isMaintain) {
        cell.maintainHistory = self.historyVm.dataSource[indexPath.row];
    }else{
        cell.history = self.historyVm.dataSource[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:kCellIdentifierVinHistoryCell configuration:^(CWTVinHistoryCell *cell) {
        if (self.isMaintain) {
            cell.maintainHistory = self.historyVm.dataSource[indexPath.row];
        }else{
            cell.history = self.historyVm.dataSource[indexPath.row];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0/[[UIScreen mainScreen] scale];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0/[[UIScreen mainScreen] scale];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isMaintain) {
        CWTMaintainHistory *carHistory = self.historyVm.dataSource[indexPath.row];
        [self getCarHistroyDetailURL:carHistory];
    } else {
        CWTVinHistory *vinHistory = self.historyVm.dataSource[indexPath.row];
        [self getVinDetailURL:vinHistory];
    }
}

#pragma mark - Go to Detail

- (void)getCarHistroyDetailURL:(CWTMaintainHistory *)histroy
{
    @weakify(self);
    [[[self.historyVm carHistoryDetailCommand] execute:histroy.reportId] subscribeNext:^(id x) {
        DLog(@"%@",[self.historyVm.reportDetailModel modelDescription]);
        @strongify(self);
        GGCarHistroyDetailWebController *detailViewVC = [[GGCarHistroyDetailWebController alloc] initWithDetailModel:self.historyVm.reportDetailModel];
        [self pushTo:detailViewVC];
    } error:^(NSError *error) {
        
    }];
}

- (void)getVinDetailURL:(CWTVinHistory *)vinInfo
{
    @weakify(self);
    [[[self.historyVm vinInfoDetailCommand] execute:vinInfo.vinQueryId] subscribeNext:^(id x) {
        DLog(@"%@",[self.historyVm.vinInfoDetailModel modelDescription]);
        @strongify(self);
        GGWebViewController *webVC = [[GGWebViewController alloc] init];
        webVC.url = self.historyVm.vinInfoDetailModel.detailUrl;
        webVC.navigationItem.title = @"VIN查询结果";
        [self pushTo:webVC];
    } error:^(NSError *error) {
        
    }];
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_car_history_empty_bg"];
}

- (CWTVinHistoryViewModel *)historyVm{
    if (!_historyVm) {
        _historyVm = [[CWTVinHistoryViewModel alloc] init];
    }
    return _historyVm;
}

@end
