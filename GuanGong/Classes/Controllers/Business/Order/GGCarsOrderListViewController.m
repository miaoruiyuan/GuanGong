//
//  GGCarsOrderListViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarsOrderListViewController.h"
#import "GGCarOrderDetailRootViewController.h"
#import "GGTransferDetailViewController.h"
#import "GGCheckCardIDViewController.h"
#import "GGModifyPriceViewController.h"
#import "GGCarOrderListCell.h"
#import "GGPaymentCodeView.h"
#import "GGOtherPayDetailViewModel.h"

@interface GGCarsOrderListViewController ()<GGPaymentCodeDelegate>

@property(nonatomic,strong)GGPaymentCodeView *codeView;
@property(nonatomic,strong)GGOtherPayDetailViewModel *otherPayVM;

@end

@implementation GGCarsOrderListViewController

- (void)bindViewModel{
    @weakify(self);
    [[self.carOrderVM.loadData.executing skip:1] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.emptyDataDisplay = !x.boolValue;
    }];
}

- (void)setupView{
    self.emptyDataTitle = @"暂无相关订单";

    [self.baseTableView registerClass:[GGCarOrderListCell class] forCellReuseIdentifier:kCellIdentifierCarOrderList];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.enabledRefreshHeader = YES;
    self.enabledRefreshFooter = YES;
    [self beginHeaderRefreshing];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"car_ordey_list_empt_icon"];
}

- (void)refreshHeaderAction{
    [self refresh];
}

- (void)refreshFooterAction{
    [self refreshMore];
}

- (void)refresh{
    if (self.carOrderVM.isLoading) {
        return;
    }
    self.carOrderVM.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshMore{
    if (self.carOrderVM.isLoading || !self.carOrderVM.canLoadMore) {
        [self footerEndNoMoreData];
        return;
    }
    self.carOrderVM.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest{
    @weakify(self);
    [[self.carOrderVM.loadData execute:0] subscribeError:^(NSError *error) {
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

#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = self.carOrderVM.dataSource.count;
    tableView.mj_footer.hidden = count > 6 ? NO : YES;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGCarOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCarOrderList];
    cell.orderDetail = self.carOrderVM.dataSource[indexPath.section];
    @weakify(self);
    [cell setFunctionButtonBlock:^(NSString *title) {
        @strongify(self);
        [self cellButtonActionWithTitle:title andObject:self.carOrderVM.dataSource[indexPath.section]];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:12 hasSectionLine:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 156;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return 12;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GGCarOrderDetail *orderDetail = self.carOrderVM.dataSource[indexPath.section];
    
    GGCarOrderDetailRootViewController *detailVC = [[GGCarOrderDetailRootViewController alloc] init];
    detailVC.orderDetail = orderDetail;
    detailVC.isSeller = self.isSeller;
    detailVC.popHandler = ^(id value) {
        [self beginHeaderRefreshing];
    };
    [self pushTo:detailVC];
}


#pragma mark -
- (void)cellButtonActionWithTitle:(NSString *)title andObject:(GGCarOrderDetail *)orderDetail{
    @weakify(self);
    if ([title isEqualToString:@"确认收货"]) {
        self.carOrderVM.orderDetail = orderDetail;
        [self.codeView show];
    } else if ([title isEqualToString:@"修改价格"]){
        GGModifyPriceViewController *modifyVC = [[GGModifyPriceViewController alloc] init];
        modifyVC.value = RACTuplePack(orderDetail.dealPrice,orderDetail.orderNo);
        [modifyVC setPopHandler:^(NSNumber *value) {
            [self beginHeaderRefreshing];
        }];
        [self pushTo:modifyVC];
    } else if ([title isEqualToString:@"取消代付"]){
        [UIAlertController alertInController:self title:@"确定取消代付？" message:nil confrimBtn:@"确认" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
            [[self.otherPayVM.cancelApplyCommand execute:orderDetail.payAnotherId] subscribeCompleted:^{
                @strongify(self);
                [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
                [self beginHeaderRefreshing];
            }];
        } cancelBtn:@"取消" cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
    } else {
        GGTransferAccountViewModel *accountVM = [[GGTransferAccountViewModel alloc] init];
        accountVM.account.realName = orderDetail.car.user.realName;
        accountVM.account.mobile = orderDetail.car.user.mobile;
        accountVM.account.userId = orderDetail.car.user.userId;
        accountVM.trade.orderNo = orderDetail.orderNo;
        accountVM.goodsType = GoodsTypeCar;
        
        if ([title isEqualToString:@"支付订金"]) {
            accountVM.payType = PaymentTypeFDJ;
            accountVM.trade.tranAmount = [NSString stringWithFormat:@"%@",orderDetail.reservePrice];
        }else if ([title isEqualToString:@"支付尾款"]){
            accountVM.payType = PaymentTypeFWK;
            accountVM.trade.tranAmount = [NSString stringWithFormat:@"%@",orderDetail.finalPrice];
        }
        
        GGTransferDetailViewController *transferDetailVC = [[GGTransferDetailViewController alloc] initWithObject:accountVM];
        [transferDetailVC setPopHandler:^(NSNumber *value){
            if(value.boolValue){
                [self beginHeaderRefreshing];
            }
        }];
        [[self class] presentVC:transferDetailVC];
    }
}

#pragma mark -  ViewModel

- (GGCarOrderViewModel *)carOrderVM{
    if (!_carOrderVM) {
        _carOrderVM = [[GGCarOrderViewModel alloc] init];
    }
    return _carOrderVM;
}

- (GGOtherPayDetailViewModel *)otherPayVM
{
    if (!_otherPayVM) {
        _otherPayVM = [[GGOtherPayDetailViewModel alloc] init];
    }
    return _otherPayVM;
}


#pragma mark - GGPaymentCodeDelegate

- (void)didTappedConfirmButtonWithpaymentPassword:(NSString *)paymentPassword{
    
    [self.codeView dismiss];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[self.carOrderVM.confirmGoodsCommand execute:paymentPassword]subscribeError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } completed:^{
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

@end
