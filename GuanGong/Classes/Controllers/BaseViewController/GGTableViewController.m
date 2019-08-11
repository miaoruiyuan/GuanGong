//
//  GGTableViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewController.h"

@interface GGTableViewController ()

@property(nonatomic,strong)MJRefreshStateHeader *refreshHeader;
@property(nonatomic,strong)MJRefreshAutoStateFooter *refreshFooter;

@end

@implementation GGTableViewController

- (void)viewDidLoad{
    self.style = UITableViewStyleGrouped;
    [super viewDidLoad];
}

#pragma mark - TableViewDataSource & Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}


#pragma mark - PublicMothd

- (void)beginHeaderRefreshing{
    self.refreshFooter.hidden = YES;
    [self.refreshHeader beginRefreshing];
}

- (void)endRefreshHeader{
    [self.refreshHeader endRefreshing];
}

- (void)refreshHeaderAction{
    
}

- (void)beginFooterRefreshing{
    [self.refreshFooter beginRefreshing];
}

- (void)endRefreshFooter{
    [self.refreshFooter endRefreshing];
}

- (void)refreshFooterAction{
    
}

- (void)footerEndNoMoreData{
    [self.refreshFooter endRefreshingWithNoMoreData];
}

#pragma mark - Getter
- (UITableView *)baseTableView{
    if (!_baseTableView) {
        _baseTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.style];
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _baseTableView.delegate = self;
        _baseTableView.dataSource = self;
        _baseTableView.emptyDataSetSource = self;
        _baseTableView.emptyDataSetDelegate = self;
        _baseTableView.backgroundColor = tableBgColor;
        _baseTableView.estimatedSectionFooterHeight = 0;
        _baseTableView.estimatedSectionHeaderHeight = 0;
        [self.view addSubview:_baseTableView];
    }
    return _baseTableView;
}

- (MJRefreshStateHeader *)refreshHeader{
    if (!_refreshHeader) {
        _refreshHeader = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderAction)];
        _refreshHeader.stateLabel.textColor = [UIColor colorWithHexString:@"d1d1d1"];
        _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    }
    return _refreshHeader;
}

- (MJRefreshAutoStateFooter *)refreshFooter{
    if (!_refreshFooter) {
        _refreshFooter = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooterAction)];
        _refreshFooter.stateLabel.textColor = [UIColor colorWithHexString:@"d1d1d1"];
    }
    return _refreshFooter;
}

#pragma mark - Setter

- (void)setEnabledRefreshHeader:(BOOL)enabledRefreshHeader{
    if (_enabledRefreshHeader != enabledRefreshHeader) {
        _enabledRefreshHeader = enabledRefreshHeader;
        self.baseTableView.mj_header = _enabledRefreshHeader ? self.refreshHeader : nil;
    }
}

- (void)setEnabledRefreshFooter:(BOOL)enabledRefreshFooter{
    if (_enabledRefreshFooter != enabledRefreshFooter) {
        _enabledRefreshFooter = enabledRefreshFooter;
        self.baseTableView.mj_footer = _enabledRefreshFooter ? self.refreshFooter : nil;
    }
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc]initWithString:self.emptyDataTitle ? self.emptyDataTitle : @""
                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16 weight:UIFontWeightBold]}];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    return [[NSAttributedString alloc] initWithString:self.emptyDataMessage ? self.emptyDataMessage : @""
                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14 weight:UIFontWeightMedium]}];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return nil;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return self.emptyDataDisplay;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -40;
}

- (void)setEmptyDataDisplay:(BOOL)emptyDataDisplay{
    if (_emptyDataDisplay != emptyDataDisplay) {
        _emptyDataDisplay = emptyDataDisplay;
        [self.baseTableView reloadEmptyDataSet];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
