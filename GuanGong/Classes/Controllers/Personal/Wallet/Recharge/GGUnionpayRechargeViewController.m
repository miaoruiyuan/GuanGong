//
//  GGUnionpayRechargeViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/7/21.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGUnionpayRechargeViewController.h"

#import "GGWithdrawCashCardCell.h"
#import "GGTextFileldCell.h"
#import "GGBankCard.h"
#import "GGFooterView.h"
#import "GGCalculationFeeView.h"
#import "GGPaymentCodeView.h"

#import "GGMessageCodeViewController.h"
#import "GGSetPayPasswordViewController.h"
#import "GGUnionpayRechargeCardListViewController.h"
#import "GGUnionPayWebViewController.h"

@interface GGUnionpayRechargeViewController ()<GGPaymentCodeDelegate>
{
    
}

@property(nonatomic,strong)GGFooterView *nextView;

@property(nonatomic,strong)GGPaymentCodeView *paymentCodeView;

@property(nonatomic,assign)NSInteger sectionCount;

@property(nonatomic,strong)GGBankRechargeViewModel *rechargeVM;


@end

@implementation GGUnionpayRechargeViewController

- (instancetype)initWithViewModel:(GGBankRechargeViewModel *)rechargeVM
{
    self = [super init];
    if (self){
        _rechargeVM = rechargeVM;
    }
    return self;
}


- (void)bindViewModel
{
    RAC(self.nextView.footerButton,enabled) = [RACSignal combineLatest:@[RACObserve(self.rechargeVM, defaultBankModel),RACObserve(self.rechargeVM,rechargeAmount)] reduce:^id(GGBankRechargeListModel *bankCard,NSString *rechargeAmount){
        return @(bankCard.openId.length > 0 && rechargeAmount.length > 0);
    }];
    
    @weakify(self);
    [[self.nextView.footerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:NO];
        
        [[self.rechargeVM.calculationFeeCommand execute:nil] subscribeNext:^(NSDictionary  *dic) {
            GGcalculationFee *model = [GGcalculationFee modelWithJSON:dic];
            [[[GGCalculationFeeView alloc] init] showRechargeWithModel:model andNextBlock:^{
                @strongify(self);
                [self showInputPayCodeView];
            }];
        } error:^(NSError *error) {
            
        }];
    }];
    
    [self getOpenCardList];
}


- (void)getOpenCardList
{
    @weakify(self);
    [[self.rechargeVM.getOpenedCardListCommand execute:nil] subscribeError:^(NSError *error) {
        @strongify(self);
        self.sectionCount = 2;
        self.baseTableView.tableFooterView = self.nextView;
        [self.baseTableView reloadData];
    } completed:^{
        @strongify(self);
        self.sectionCount = 2;
        self.baseTableView.tableFooterView = self.nextView;
        [self.baseTableView reloadData];
    }];
}

- (void)setupView
{
    self.navigationItem.title = @"银行卡充值";
    [self.baseTableView registerClass:[GGWithdrawCashCardCell class] forCellReuseIdentifier:kCellIdentifierWithdrawCashCell];
    [self.baseTableView registerClass:[GGTextFileldCell class] forCellReuseIdentifier:kCellIdentifierTextField];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)gotoAddCardH5View
{
    @weakify(self);
    [[[self.rechargeVM openCardApplyCommand] execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        if (self.rechargeVM.payOpenModel) {
            GGUnionPayWebViewController *webView = [[GGUnionPayWebViewController alloc] initWithUnionOpenModel:self.rechargeVM.payOpenModel];
            [webView setPopHandler:^(id value){
                [self getOpenCardList];
            }];
            [self pushTo:webView];
        }
    }];
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
        [cell showRechargeView:self.rechargeVM.defaultBankModel];
        return cell;
    }else{
        GGTextFileldCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTextField forIndexPath:indexPath];
        cell.textField.placeholder = @"充值金额";
        cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        @weakify(self);
        [[[cell.textField rac_textSignal] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString *value) {
            @strongify(self);
            self.rechargeVM.rechargeAmount = value;
        }];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 36)];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.width - 40, 36)];
        textLabel.numberOfLines = 2;
        
        if (self.rechargeVM.defaultBankModel) {
            if ([self.rechargeVM.defaultBankModel.cardType isEqualToString:@"01"]) {
                textLabel.text = self.rechargeVM.rateModel.debitRateRemark;
            } else {
                textLabel.text = self.rechargeVM.rateModel.creditRateRemark;
            }
        } else {
            textLabel.text = self.rechargeVM.rateModel.chargeRateRemark;
        }
        
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
        if(self.rechargeVM.defaultBankModel){
            return 80;
        } else {
            return 60;
        }
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (self.rechargeVM.defaultBankModel) {
            GGUnionpayRechargeCardListViewController *listVC = [[GGUnionpayRechargeCardListViewController alloc] init];
            listVC.popHandler = ^(GGBankRechargeListModel *model){
                self.rechargeVM.defaultBankModel = model;
                [self.baseTableView reloadData];
            };
            [self pushTo:listVC];
        }else{
            [self gotoAddCardH5View];
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
        return 36;
    }
    return 10;
}

- (void)showInputPayCodeView
{
    //判断是否设置了支付密码
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


#pragma mark - GGPaymentCodeDelegate
- (void)didTappedConfirmButtonWithpaymentPassword:(NSString *)paymentPassword{
    
    [self.paymentCodeView dismiss];
    [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
    
    @weakify(self);
    [[self.rechargeVM.sendPaySMSCommand execute:paymentPassword] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
        GGMessageCodeViewController *messagesVC = [[GGMessageCodeViewController alloc] init];
        messagesVC.rechargeVM = self.rechargeVM;
        [messagesVC setPopHandler:^(id value){
            [self pop];
        }];
        [[self class] presentVC:messagesVC];
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


#pragma mark - init View

- (GGFooterView *)nextView
{
    if (!_nextView) {
        _nextView = [[GGFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 88) andFootButtonTitle:@"确认充值"];
    }
    return _nextView;
}

@end
