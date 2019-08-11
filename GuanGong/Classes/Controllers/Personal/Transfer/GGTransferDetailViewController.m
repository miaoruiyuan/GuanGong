//
//  GGTransferDetailViewController.m
//  GuanGong
//  支付详情 （支付成功 支付跳转）
//  Created by 苗芮源 on 16/8/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTransferDetailViewController.h"
#import "GGTransferDetailCell.h"
#import "GGTransferModeCell.h"
#import "GGFooterView.h"
#import "GGPaymentCodeView.h"

#import "GGPaymentOrderRootViewController.h"
#import "GGMyFriendsViewController.h"
#import "GGCheckCardIDViewController.h"
#import "GGTransferSuccessfulViewController.h"
#import "GGCarOrderViewModel.h"

@interface GGTransferDetailViewController ()<GGPaymentCodeDelegate>

@property(nonatomic,strong)GGTransferAccountViewModel *accountVM;
@property(nonatomic,strong)GGFooterView *footerView;
@property(nonatomic,strong)GGPaymentCodeView *codeView;

@end

@implementation GGTransferDetailViewController

- (instancetype)initWithObject:(GGTransferAccountViewModel *)accountVM{
    if (self = [super init]) {
        self.accountVM = accountVM;
    }
    return self;
}

- (void)setupView
{
    self.style = UITableViewStylePlain;
    self.navigationItem.title = @"支付详情";
    [self.baseTableView registerClass:[GGTransferDetailCell class] forCellReuseIdentifier:kCellIdentifierTransferDetails];
    [self.baseTableView registerClass:[GGTransferModeCell class] forCellReuseIdentifier:kCellIdentifierTransferMode];
    self.baseTableView.tableFooterView = self.footerView;
}

- (void)bindViewModel
{
    RAC(self.footerView.footerButton,enabled) = self.accountVM.enabelSureSignal;
    //确认按钮
    @weakify(self);
    [[self.footerView.footerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.accountVM.isOtherPay) {
            GGMyFriendsViewController *myFriendsVC = [[GGMyFriendsViewController alloc] init];
            myFriendsVC.isTransfer = NO;
            myFriendsVC.friensVM.applyAmount = [self.accountVM.trade.tranAmount numberValue];
            myFriendsVC.friensVM.remark = self.accountVM.trade.reserve;
            myFriendsVC.friensVM.salerId = self.accountVM.account.userId;
            myFriendsVC.friensVM.orderNo = self.accountVM.trade.orderNo;
            
            switch (self.accountVM.payType) {
                case PaymentTypeFDJ:
                    myFriendsVC.friensVM.goodsStatusId = @2;
                    break;
                    
                case PaymentTypeFWK:
                    myFriendsVC.friensVM.goodsStatusId = @5;
                    break;
                    
                case PaymentTypeFQK:
                    myFriendsVC.friensVM.goodsStatusId = @18;
                    break;
                    
                default:
                    break;
            }
            
            [myFriendsVC setPopHandler:^(id obj) {
                @strongify(self);
                [self otherPaypopToVC];
            }];
            [[self class] presentVC:myFriendsVC];
        }else{
            [self.codeView show];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
            
        default:
            return self.accountVM.isTransfer ? 1 : 2;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GGTransferDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTransferDetails];
        cell.accountVM = self.accountVM;
        return cell;
    }else{
        GGTransferModeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTransferMode];
        if (indexPath.row == 0) {
            [cell updateUIWithModeName:@"余额支付" modeImageName:@"balance_pay"];
        }else{
            [cell updateUIWithModeName:@"朋友代付" modeImageName:@"other_pay"];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [cell setSelected:indexPath.row == 0 ? !self.accountVM.isOtherPay : self.accountVM.isOtherPay animated:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 110;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        self.accountVM.isOtherPay = indexPath.row == 0 ? NO : YES;
    }
    [tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - GGPaymentCodeDelegate

- (void)didTappedConfirmButtonWithpaymentPassword:(NSString *)paymentPassword{
    [self.codeView dismiss];
    
    @weakify(self);
    [MBProgressHUD showMessage:@"请稍后" toView:self.view];
    
    self.accountVM.trade.password = paymentPassword;
    
    [[self.accountVM.transferCommand execute:0] subscribeError:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
    } completed:^{
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:GGTransferSuccessNotification object:nil];
        
        if (self.accountVM.isTransfer) {
            //如果是质检支付
            if (self.accountVM.goodsType == GoodsTypeCheckCar) {
                [MBProgressHUD showSuccess:@"支付成功" toView:self.view];
                [self bk_performBlock:^(GGTransferDetailViewController *obj) {
                    [obj dismissViewControllerAnimated:YES completion:^{
                        if (self.popHandler) {
                            self.popHandler(@1);
                        }
                    }];
                } afterDelay:1.1];
            } else {
                GGTransferSuccessfulViewController *vc = [[GGTransferSuccessfulViewController alloc] init];
                vc.accountVM = self.accountVM;
                if (self.popHandler) {
                    [vc setPopHandler:^(id value){
                        self.popHandler(@YES);
                        [self dismiss];
                    }];
                }
                [self pushTo:vc];
            }
        }else{
            if (self.accountVM.payType == PaymentTypeFQK || self.accountVM.payType == PaymentTypeFWK){
                [UIAlertController alertInController:self title:@"支付成功" message:nil confrimBtn:@"知道了" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
                    [self popToOtherViewController];
                } cancelBtn:nil cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
            }else if (self.accountVM.payType == PaymentTypeFDJ) {
                [UIAlertController alertInController:self title:@"支付成功，资金暂存在关二爷担保账户中" message:nil confrimBtn:@"知道了" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
                    [self popToOtherViewController];
                } cancelBtn:nil cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
            }else{
                [self popToOtherViewController];
            }
        }
    }];
}

- (void)didTappedForgetPasswordButton
{
    GGCheckCardIDViewController *setPayPassVC = [[GGCheckCardIDViewController alloc] init];
    [[self class] presentVC:setPayPassVC];
}

- (void)didTappedColseButton
{
    
}

#pragma mark - 代付申请完成跳转
- (void)otherPaypopToVC
{
    if (self.popHandler) {
        self.popHandler(@YES);
        [self dismiss];
        return;
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[GGPaymentOrderRootViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:GGRefreshBuyerListNotification object:nil];
            return ;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:GGOtherPaySuccessNotification object:nil];
}

#pragma mark - Pay Success POP 支付完成跳转

- (void)popToOtherViewController
{
    if (self.popHandler) {
        self.popHandler(@YES);
        [self dismiss];
        return;
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[GGPaymentOrderRootViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:GGRefreshBuyerListNotification object:nil];
            return ;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    if (self.accountVM.goodsType == GoodsTypeSafePay) {
        [self bk_performBlock:^(GGTransferDetailViewController *obj) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GGPaymentSuccessNotification object:nil];
        } afterDelay:0.2f];
    }
}

- (void)navigationCloseBtnClicked
{
    self.popHandler(@NO);
    [self dismiss];
}

#pragma mark - init View

- (GGFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[GGFooterView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,100) andFootButtonTitle:@"确定"];
    }
    return _footerView;
}

- (GGPaymentCodeView *)codeView
{
    if (!_codeView) {
        _codeView = [[GGPaymentCodeView alloc] init];
        _codeView.delegate = self;
    }
    return _codeView;
}

@end
