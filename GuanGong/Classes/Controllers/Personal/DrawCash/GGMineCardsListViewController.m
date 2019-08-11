//
//  GGCardListViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMineCardsListViewController.h"
#import "GGSetPayPasswordViewController.h"
#import "GGAddCardViewController.h"
#import "GGBankCardCell.h"
#import "GGPaymentCodeView.h"
#import "GGWithdrawViewModel.h"
#import "GGBankCard.h"
#import "GGCheckCardIDViewController.h"

@interface GGMineCardsListViewController ()<GGPaymentCodeDelegate>
@property(nonatomic,strong)GGWithdrawViewModel *withDrawVM;

@property(nonatomic,strong)GGPaymentCodeView *codeView;

@end

@implementation GGMineCardsListViewController


- (GGWithdrawViewModel *)withDrawVM{
    if (!_withDrawVM) {
        _withDrawVM = [[GGWithdrawViewModel alloc]init];
    }
    return _withDrawVM;
}


- (void)bindViewModel{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:GGBindCardSuccessNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self loadCardsList];
    }];
    
    [[self.withDrawVM.bankCardsCommand.executing skip:1] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.emptyDataDisplay = !x.boolValue;
    }];
}

- (void)setupView{
    self.navigationItem.title = @"我的银行卡";
    [self.baseTableView registerClass:[GGBankCardCell class] forCellReuseIdentifier:kCellIdentifierBankCardCell];
    self.baseTableView.showsVerticalScrollIndicator = NO;
    self.baseTableView.rowHeight = 124;
    self.emptyDataTitle = @"您还没有添加过银行卡";
    self.emptyDataMessage = @"点击右上角添加";
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]bk_initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                handler:^(id sender) {
        
        GGAddCardViewController *addVC = [[GGAddCardViewController alloc] init];
        [GGMineCardsListViewController presentVC:addVC];
        [MobClick event:@"addbankcard"];
    }];

    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self loadCardsList];
}

#pragma mark - 获取银行卡列表
- (void)loadCardsList{
    @weakify(self);
    [[self.withDrawVM.bankCardsCommand execute:0] subscribeCompleted:^{
        @strongify(self);
        [self.baseTableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.withDrawVM.cards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierBankCardCell forIndexPath:indexPath];
    cell.card = self.withDrawVM.cards[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"解绑";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GGBankCard *card = self.withDrawVM.cards[indexPath.row];
    self.withDrawVM.acctId = card.idCode;

    
    if (![GGLogin shareUser].haveSetPayPassword) {
        [UIAlertController alertInController:self title:@"未设置支付密码" message:@"没有支付密码不可以解绑" confrimBtn:@"去设置" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
            GGSetPayPasswordViewController *setPayVC = [[GGSetPayPasswordViewController alloc] init];
            [GGMineCardsListViewController presentVC:setPayVC];
        } cancelBtn:@"算了" cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
    }else{
       [self.codeView show];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGBankCard *card = self.withDrawVM.cards[indexPath.row];
    if (self.cardInfo) {
        self.cardInfo(card);
        [self pop];
    }
}

- (void)didTappedConfirmButtonWithpaymentPassword:(NSString *)paymentPassword{
    [self.codeView dismiss];
    [MBProgressHUD showMessage:@"解绑中..." toView:self.view];
    @weakify(self);
    [[self.withDrawVM.unBindingCommand execute:paymentPassword] subscribeError:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
    } completed:^{
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showSuccess:@"解绑成功" toView:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:GGUpdataCardListNotification object:nil];
        [self loadCardsList];
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
        _codeView = [[GGPaymentCodeView alloc] init];
        _codeView.delegate = self;
    }
    return _codeView;
}


@end
