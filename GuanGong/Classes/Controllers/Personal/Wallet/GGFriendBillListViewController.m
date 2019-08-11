//
//  GGFriendBillListViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/3/20.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGFriendBillListViewController.h"
#import "GGBillListViewModel.h"
#import "GGBillingDetailsViewController.h"
#import "GGFriendBillListCell.h"


@interface GGFriendBillListViewController ()

@property(nonatomic,strong)GGBillListViewModel *billListVM;

@end

@implementation GGFriendBillListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView
{
    self.navigationItem.title = @"交易记录";
    self.style = UITableViewStylePlain;
    self.emptyDataTitle = @"没有相关记录";
    [self.baseTableView registerClass:[GGFriendBillListCell class] forCellReuseIdentifier:NSStringFromClass([GGFriendBillListCell class])];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.enabledRefreshHeader = YES;
    self.enabledRefreshFooter = YES;
    
    [self beginHeaderRefreshing];
}

- (void)bindViewModel{
    
    _billListVM = [[GGBillListViewModel alloc]init];
    _billListVM.otherUserId = self.otherUserID;
    @weakify(self);
    [[self.billListVM.loadData.executing skip:1] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.emptyDataDisplay = !x.boolValue;
    }];
}


- (void)refreshHeaderAction{
    if (self.billListVM.isLoading) {
        return;
    }
    self.billListVM.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshFooterAction{
    if (self.billListVM.isLoading || !self.billListVM.canLoadMore) {
        [self footerEndNoMoreData];
        return;
    }
    self.billListVM.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest{
    
    @weakify(self);
    [[self.billListVM.loadData execute:0] subscribeError:^(NSError *error) {
        @strongify(self);
        [self endRefreshHeader];
        [self endRefreshFooter];
        NSInteger count = self.billListVM.billList.result.count;
        self.baseTableView.mj_footer.hidden = count > 8 ? NO : YES;
    } completed:^{
        @strongify(self);
        [self endRefreshHeader];
        [self endRefreshFooter];
        [self.baseTableView reloadData];
        NSInteger count = self.billListVM.billList.result.count;
        self.baseTableView.mj_footer.hidden = count > 8 ? NO : YES;
    }];
}


#pragma mark TableM

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  [self.billListVM sectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.billListVM itemCountAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGFriendBillListCell *billCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GGFriendBillListCell class])];
    [billCell updateUIWithModel:[self.billListVM itemForIndexPath:indexPath]];
    return billCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    GGBillingDetailsViewController *detailsVC = [[GGBillingDetailsViewController alloc]init];
    detailsVC.item = [self.billListVM itemForIndexPath:indexPath];;
    [self pushTo:detailsVC];
    [MobClick event:@"detailofbill"];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
    view.backgroundColor = tableBgColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.width - 20, 30)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = textLightColor;
    label.text = [self.billListVM getSectionTitle:section];
    [view addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, tableView.width, 0.5f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"0xdddddd"];
    [view addSubview:lineView];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


@end
