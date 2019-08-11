//
//  GGWalletViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGWalletViewController.h"

#import "GGBillListViewController.h"
#import "GGMineCardsListViewController.h"
#import "GGRechageListViewController.h"
#import "GGTransferEnterViewController.h"
#import "GGWithDrawCashViewController.h"

#import "GGWalletBalanceCell.h"
#import "GGWalletToolsCell.h"
#import "TTTAttributedLabel.h"
#import "GGWithdrawViewModel.h"
#import "GGAddCardViewController.h"


@interface GGWalletViewController ()<WalletToolsBarDelegate,TTTAttributedLabelDelegate>

@property(nonatomic,strong)GGWallet *wallet;
@property(nonatomic,strong)TTTAttributedLabel *helpLabel;
@property(nonatomic,strong)GGWithdrawViewModel *drawVM;

@end

@implementation GGWalletViewController

- (void)bindViewModel
{
    self.drawVM = [[GGWithdrawViewModel alloc] init];
    [[self.drawVM bankCardsCommand] execute:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)setupView
{
    self.navigationItem.title = @"我的钱包";
    [self.baseTableView registerClass:[GGWalletBalanceCell class] forCellReuseIdentifier:kCellIdentifierWalletBalance];
    [self.baseTableView registerClass:[GGWalletToolsCell class] forCellReuseIdentifier:kCellIdentifierWalletTools];
    
    self.enabledRefreshHeader = YES;
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                            bk_initWithTitle:@"账单"
                                                  style:UIBarButtonItemStylePlain
                                                handler:^(id sender) {
                                                    @strongify(self);
                                                    GGBillListViewController *billVC =
                                                    [[GGBillListViewController alloc]init];
                                                    [self pushTo:billVC];
                                                    [MobClick event:@"bill"];

                                                }];

    [self.view addSubview:self.helpLabel];
    [self.helpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.height.mas_offset(15);
        make.left.right.equalTo(self.view);
    }];
}

- (void)refreshHeaderAction
{
    [self refresh];
}

#pragma mark - 获取账户余额

- (void)refresh
{
    [[[GGApiManager request_AccountInfo] map:^id(NSDictionary *value) {
        GGWallet *wallet = [GGWallet modelWithDictionary:value];
        self.wallet = wallet;
        [[GGLogin shareUser] updateAmount:wallet];
        return [RACSignal empty];
    }] subscribeError:^(NSError *error) {
        [self endRefreshHeader];
    } completed:^{
        [self endRefreshHeader];
        [self.baseTableView reloadData];
    }];
}


#pragma mark TableM
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        GGWalletBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierWalletBalance];
        cell.wallet = self.wallet;
        return cell;
    }else{
        GGWalletToolsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierWalletTools forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 340;
    }else{
        return 80;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3.0;
}

#pragma mark - WalletToolsBarDelegate
- (void)selectWalletToolBarButtonIndex:(NSInteger)index
{
    switch (index) {
        case 29:{
            
            GGRechageListViewController *rechargeListVC = [[GGRechageListViewController alloc]init];
            [self pushTo:rechargeListVC];
            [MobClick event:@"topup"];
//
//            if ([GGLogin shareUser].cards.count > 0) {
//                GGRechargeViewController *rechargeVC = [[GGRechargeViewController alloc]init];
//                [self pushTo:rechargeVC];
//                [MobClick event:@"topup"];
//            } else {
//                @weakify(self);
//                [UIAlertController alertInController:self title:@"请绑定银行卡，并用绑定银行卡进行充值" message:@"" confrimBtn:@"去绑定" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
//                    GGAddCardViewController *addCardVC = [[GGAddCardViewController alloc] init];
//                    addCardVC.popHandler = ^(id value) {
//                        @strongify(self);
//                        [self bk_performBlock:^(GGWalletViewController *obj) {
//                            GGRechargeViewController *rechargeVC = [[GGRechargeViewController alloc] init];
//                            [obj pushTo:rechargeVC];
//                        } afterDelay:0.3f];
//                    };
//                    [[self class] presentVC:addCardVC];
//                } cancelBtn:@"取消" cancelStyle:UIAlertActionStyleCancel cancelAction:^{
//                }];
//            }
        }
            break;
            
        case 30:{
            GGWithdrawCashViewController *cashVC = [[GGWithdrawCashViewController alloc]init];
            [self pushTo:cashVC];
            [MobClick event:@"withdrawal"];
        }
            break;
            
        case 31:{
            GGTransferEnterViewController *transferVC = [[GGTransferEnterViewController alloc]init];
            transferVC.isTransfer = YES;
            [self pushTo:transferVC];
            [MobClick event:@"transfer"];
        }
            break;
            
        default:{
            GGMineCardsListViewController *cardVC = [[GGMineCardsListViewController alloc]init];
            [self pushTo:cardVC];
            [MobClick event:@"bankcard"];
        }
            break;
    }
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    NSString *str = [[NSString alloc] initWithFormat:@"tel:%@",phoneNumber];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (TTTAttributedLabel *)helpLabel{
    if (!_helpLabel) {
        _helpLabel = [TTTAttributedLabel new];
        _helpLabel.delegate = self;
        _helpLabel.textAlignment = NSTextAlignmentCenter;
        [_helpLabel addLinkToPhoneNumber:@"400-822-0063" withRange:NSMakeRange(7, 12)];
        _helpLabel.attributedText = [[NSAttributedString alloc] initWithString:@"支付遇到问题？400-822-0063" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13 weight:UIFontWeightThin]}];
        _helpLabel.linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"737373"],
                                      NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),
                                      NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular]};
    }
    return _helpLabel;
}

- (void)dealloc
{
    
}



@end
