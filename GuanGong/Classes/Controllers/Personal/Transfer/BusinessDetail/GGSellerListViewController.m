//
//  GGSellerListViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/18.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGSellerListViewController.h"
#import "GGRewardViewController.h"
#import "GGOrderDetailRootViewController.h"
#import "GGSellerListCell.h"
#import "GGOrderListViewModel.h"
#import "GGPaymentCodeView.h"
@interface GGSellerListViewController ()<SellerCellDelegate>

@property(nonatomic,strong)GGOrderListViewModel *orderListVM;
@property(nonatomic,strong)NSString *transStatus;

@end

@implementation GGSellerListViewController

- (void)bindViewModel{
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:GGRefreshSellerListNotification object:nil]subscribeNext:^(id x) {
        [self beginHeaderRefreshing];
    }];
    
    [[self.orderListVM.loadData.executing skip:1]subscribeNext:^(NSNumber *x) {
        self.emptyDataDisplay = !x.boolValue;
    }];
}

- (instancetype)initSellerListWithStatus:(NSString *)status
{
    self = [super init];
    if (self) {
        _transStatus = status;
    }
    return self;
}

- (void)setupView{
    self.orderListVM.type = OrderListTypePayment;
    self.orderListVM.transStatus = self.transStatus;
    
    self.baseTableView.sectionHeaderHeight = 10;
    self.baseTableView.sectionFooterHeight = 0.01;
    self.baseTableView.rowHeight = 80;
    [self.baseTableView registerClass:[GGSellerListCell class] forCellReuseIdentifier:kCellIdentifierSellerList];
    self.emptyDataTitle = @"暂无交易信息";
//    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 64, 0));
//    }];
    
    self.enabledRefreshHeader = YES;
    self.enabledRefreshFooter = YES;
    
    [self beginHeaderRefreshing];
}


- (void)refreshHeaderAction{
    if (self.orderListVM.isLoading) {
        return;
    }
    self.orderListVM.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshFooterAction{
    if (self.orderListVM.isLoading || !self.orderListVM.canLoadMore) {
        [self footerEndNoMoreData];
        return;
    }
    self.orderListVM.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest{
    [[self.orderListVM.loadData execute:@0]subscribeError:^(NSError *error) {
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
    NSInteger count = self.orderListVM.dataSource.count;
    tableView.mj_footer.hidden = count > 6 ? NO : YES;
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGOrderList *item = self.orderListVM.dataSource[indexPath.section];
    GGSellerListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierSellerList];
    cell.delegate = self;
    [cell configCellItem:item];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GGOrderList *item = self.orderListVM.dataSource[indexPath.section];
    
    GGOrderDetailRootViewController *detailsVC = [[GGOrderDetailRootViewController alloc]initWithObject:item];
    [self pushTo:detailsVC];
    
}


#pragma mark - CellDelegate
- (void)sellerCellAction:(UIButton *)sender{
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.baseTableView];
    NSIndexPath *indexPath = [self.baseTableView indexPathForRowAtPoint:rootViewPoint];
    GGOrderList *item = self.orderListVM.dataSource[indexPath.section];
    self.orderListVM.orderNo = item.orderNo;
    
    if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"打赏"]){
        
        GGRewardViewController *rewardVC = [[GGRewardViewController alloc] init];
        rewardVC.orderNo = item.orderNo;
        [GGSellerListViewController presentVC:rewardVC];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (GGOrderListViewModel *)orderListVM{
    if (!_orderListVM) {
        _orderListVM = [[GGOrderListViewModel alloc]init];
    }
    return _orderListVM;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GGRefreshSellerListNotification object:nil];
}


@end
