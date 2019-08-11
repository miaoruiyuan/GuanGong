//
//  GGWithdrawCashViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGWithdrawCashViewController.h"
#import "GGMessageCodeViewController.h"
#import "GGSetPayPasswordViewController.h"
#import "GGAddCardViewController.h"
#import "GGWithdrawCashCardCell.h"
#import "GGTextFileldCell.h"
#import "GGMineCardsListViewController.h"

#import "GGWithdrawViewModel.h"

#import "GGFooterView.h"
#import "GGPaymentCodeView.h"
#import "GGCalculationFeeView.h"

@interface GGWithdrawCashViewController ()<GGPaymentCodeDelegate>
{
}

@property(nonatomic,strong)GGFooterView *nextView;
@property(nonatomic,strong)GGWithdrawViewModel *withDrawVM;
@property(nonatomic,strong)GGPaymentCodeView *paymentCodeView;
@property(nonatomic,assign)NSInteger sectionCount;

@end

@implementation GGWithdrawCashViewController

- (GGWithdrawViewModel *)withDrawVM
{
    if (!_withDrawVM) {
        _withDrawVM = [[GGWithdrawViewModel alloc]init];
    }
    return _withDrawVM;
}

- (void)bindViewModel
{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:GGUpdataCardListNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self bankCardRequest];
    }];
    RAC(self.nextView.footerButton,enabled) = self.withDrawVM.enableSignal;
}

- (void)bankCardRequest
{
    [[self.withDrawVM.bankCardsCommand execute:nil] subscribeNext:^(id x) {
        self.sectionCount = 2;
        self.baseTableView.tableFooterView = self.nextView;
        [self.baseTableView reloadData];
    }];
}

- (void)setupView
{
    self.navigationItem.title = @"提现";
    [self.baseTableView registerClass:[GGWithdrawCashCardCell class] forCellReuseIdentifier:kCellIdentifierWithdrawCashCell];
    [self.baseTableView registerClass:[GGTextFileldCell class] forCellReuseIdentifier:kCellIdentifierTextField];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self bankCardRequest];

    @weakify(self);
    [[self.nextView.footerButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:NO];
        [[self.withDrawVM.calculationFeeCommand execute:self.withDrawVM.tranAmount] subscribeNext:^(NSDictionary  *dic) {
            GGcalculationFee *model = [GGcalculationFee modelWithJSON:dic];
            [[[GGCalculationFeeView alloc] init] showWithModel:model andNextBlock:^{
                if (([model.amount floatValue] + [model.fee floatValue]) > [GGLogin shareUser].wallet.totalTranOutAmount.floatValue) {
                    kTipAlert(@"您账户的可提现余额不足！");
                }else{
                    @strongify(self);
                    [self showInputPayCodeView];
                }
            }];
        } error:^(NSError *error) {
            
        }];
    }];
}

- (void)showInputPayCodeView
{
    if (![GGLogin shareUser].haveSetPayPassword) {
        [UIAlertController alertInController:self
                                       title:@"使用此功能之前需要设置支付密码哦"
                                     message:nil
                                  confrimBtn:@"去设置"
                                confrimStyle:UIAlertActionStyleDefault
                               confrimAction:^{
                                   GGSetPayPasswordViewController *setPVC = [[GGSetPayPasswordViewController alloc] init];
                                   [[self class] presentVC:setPVC];
                               }
                                   cancelBtn:@"取消"
                                 cancelStyle:UIAlertActionStyleCancel
                                cancelAction:^{}];
        
    } else {
        self.paymentCodeView = [[GGPaymentCodeView alloc] init];
        self.paymentCodeView.delegate = self;
        [self.paymentCodeView show];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GGWithdrawCashCardCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierWithdrawCashCell forIndexPath:indexPath];
        cell.bankCard = self.withDrawVM.bankCard;
        return cell;
    }else{
        GGTextFileldCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTextField forIndexPath:indexPath];
        NSString *moneyString =  [NSString stringWithFormat:@"本次最多提现%0.2f元",[GGLogin shareUser].wallet.totalTranOutAmount.floatValue];
        cell.textField.placeholder = moneyString;
        cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        RAC(self.withDrawVM,tranAmount) = [cell.textField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.width - 40, 30)];
        textLabel.text = @"单日限额100万元，支持5万元以下额度两小时内到账";
        textLabel.font = [UIFont systemFontOfSize:13];
        textLabel.textColor = [UIColor darkGrayColor];
        [view addSubview:textLabel];
        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.withDrawVM.bankCard) {
            return 80;
        }else{
            return 64;
        }
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (self.withDrawVM.bankCard) {
            GGMineCardsListViewController *listVC = [[GGMineCardsListViewController alloc] init];
            listVC.cardInfo = ^(GGBankCard *card){
                self.withDrawVM.bankCard  = card;
                [self.baseTableView reloadData];
            };
            [self.navigationController pushViewController:listVC animated:YES];
        }else{
            GGAddCardViewController *addCardVC = [[GGAddCardViewController alloc] init];
            [GGWithdrawCashViewController presentVC:addCardVC];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 0.01;
}

- (GGFooterView *)nextView
{
    if (!_nextView) {
        _nextView = [[GGFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100) andFootButtonTitle:@"确认提现"];
    }
    return _nextView;
}


#pragma mark - GGPaymentCodeViewDelegate
- (void)didTappedConfirmButtonWithpaymentPassword:(NSString *)paymentPassword{

    [self.paymentCodeView dismiss];
    [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
    
    @weakify(self);
    [[self.withDrawVM.getOrderCommand execute:paymentPassword] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
        GGMessageCodeViewController *messagesVC = [[GGMessageCodeViewController alloc]init];
        messagesVC.withDrawVM = self.withDrawVM;
        [self.navigationController pushViewController:messagesVC animated:YES];
    } error:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)didTappedColseButton
{
    DLog(@"支付视图关闭");
}

- (void)didTappedForgetPasswordButton{
    GGSetPayPasswordViewController *setPayPassVC = [[GGSetPayPasswordViewController alloc] init];
    [[self class] presentVC:setPayPassVC];
}

- (void)paymentComplete
{
    DLog(@"付款完成");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GGUpdataCardListNotification object:nil];
}

@end
