//
//  GGBuyerListViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/18.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBuyerListViewController.h"
#import "GGOrderDetailRootViewController.h"
#import "GGCheckCardIDViewController.h"
#import "GGRewardViewController.h"
#import "GGTransferViewController.h"
#import "GGBuyerListCell.h"
#import "GGOrderListViewModel.h"

#import "GGPaymentCodeView.h"
#import "GGOrderListViewModel.h"


@interface GGBuyerListViewController ()<BuyerCellDelegate,GGPaymentCodeDelegate>

@property(nonatomic,strong)GGPaymentCodeView *codeView;
@property(nonatomic,strong)GGOrderListViewModel *orderListVM;
@property(nonatomic,strong)NSString *transStatus;

@end

@implementation GGBuyerListViewController


- (instancetype)initBuyerListWithStatus:(NSString *)status
{
    self = [super init];
    if (self) {
        _transStatus = status;
    }
    return self;
}

- (void)bindViewModel{
    
    @weakify(self);

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:GGRefreshBuyerListNotification object:nil]subscribeNext:^(id x) {
        @strongify(self);
        [self sendRequest];
    }];
    
    [[self.orderListVM.loadData.executing skip:1]subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.emptyDataDisplay = !x.boolValue;
    }];
}



- (void)setupView{
    self.orderListVM.type = OrderListTypePayment;
    self.orderListVM.transStatus = self.transStatus;
    self.baseTableView.sectionHeaderHeight = 10;
    self.baseTableView.sectionFooterHeight = 0.01;
    self.baseTableView.rowHeight = 80;
    [self.baseTableView registerClass:[GGBuyerListCell class] forCellReuseIdentifier:kCellIdentifierBuyerList];
    self.emptyDataTitle = @"暂无交易信息";
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
  
    @weakify(self);

    [[self.orderListVM.loadData execute:@1] subscribeError:^(NSError *error) {
        @strongify(self);
        [self endRefreshHeader];
        [self endRefreshFooter];
    } completed:^{
        @strongify(self);
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
    GGBuyerListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierBuyerList];
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

#pragma mark - CellDelegate

- (void)buyerCellAction:(UIButton *)sender{
    
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.baseTableView];
    NSIndexPath *indexPath = [self.baseTableView indexPathForRowAtPoint:rootViewPoint];
    GGOrderList *item = self.orderListVM.dataSource[indexPath.section];
    self.orderListVM.orderNo = item.orderNo;
    
    if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"确认收货"]){
        
        NSString *title = item.hasApplyReturn ? @"此交易已提交退款申请,确认收货将关闭退款":@"请确保收到货物并满意后再确认收货";
        
        [UIAlertController alertInController:self
                                       title:title
                                     message:nil
                                  confrimBtn:@"确认收货"
                                confrimStyle:UIAlertActionStyleDefault
                               confrimAction:^{
                                   [self.codeView show];
                               }
                                   cancelBtn:@"取消"
                                 cancelStyle:UIAlertActionStyleCancel
                                cancelAction:^{
                                    
                                }];
        [MobClick event:@"list_confirmreceipt"];

    }else if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"支付尾款"]){
        
        GGAccount *account = [[GGAccount alloc]init];
        account.realName = item.dealerName;
        account.mobile = item.dealerMobile;
        account.userId = item.dealerId;
        account.icon = item.dealerIcon;
        
        GGTransferViewController *transferVC = [[GGTransferViewController alloc] initWithItem:account];
        transferVC.transferVM.isTransfer = NO;
        transferVC.transferVM.isFinalPay = YES;
        transferVC.transferVM.trade.orderNo = item.orderNo;

        if (item.statusId == OrderStatusTypeTHTK || item.statusId == OrderStatusTypeJJTK) {
            [UIAlertController alertInController:self
                                           title:@"此交易已提交退款申请，成功支付尾款后将关闭退款。"
                                         message:nil
                                      confrimBtn:@"确定支付"
                                    confrimStyle:UIAlertActionStyleDefault
                                   confrimAction:^{
                                       [self pushTo:transferVC];
                                   } cancelBtn:@"取消"
                                     cancelStyle:UIAlertActionStyleCancel
                                    cancelAction:nil];
        }else{
            [self pushTo:transferVC];
        }
        [MobClick event:@"list_finalpayment"];

    }else if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"打赏"]){
        
        GGRewardViewController *rewardVC = [[GGRewardViewController alloc] init];
        rewardVC.orderNo = item.orderNo;
        [GGBuyerListViewController presentVC:rewardVC];
        [MobClick event:@"list_reward"];
    }
}

#pragma mark -GGPaymentCodeDelegate
- (void)didTappedConfirmButtonWithpaymentPassword:(NSString *)paymentPassword{
    
    [self.codeView dismiss];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [[self.orderListVM.confirmGoods execute:paymentPassword]subscribeError:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } completed:^{
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"收货成功" toView:self.view];
        [self beginHeaderRefreshing];
    }];
}
- (void)didTappedColseButton{
    
}
- (void)didTappedForgetPasswordButton{
    
    GGCheckCardIDViewController *setPayPassVC = [[GGCheckCardIDViewController alloc] init];
    [[self class] presentVC:setPayPassVC];
}
- (void)paymentComplete{
    
}

- (GGPaymentCodeView *)codeView{
    if (!_codeView) {
        _codeView = [[GGPaymentCodeView alloc]init];
        _codeView.delegate = self;
    }
    return _codeView;
}

- (GGOrderListViewModel *)orderListVM{
    if (!_orderListVM) {
        _orderListVM = [[GGOrderListViewModel alloc]init];
    }
    return _orderListVM;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GGRefreshBuyerListNotification object:nil];
}

@end
