//
//  GGCheckBankCardViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/7/19.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGCheckBankCardViewController.h"

#import "GGWithdrawCashCardCell.h"

#import "GGMineCardsListViewController.h"

#import "GGBingNewPhoneViewController.h"

#import "GGBankCard.h"
#import "GGFooterView.h"

@interface GGCheckBankCardViewController ()
{

}

@property(nonatomic,strong)GGFooterView *nextView;

@property(nonatomic,assign)NSInteger sectionCount;

@property(nonatomic,strong)GGBankCard *bankCard;

@end

@implementation GGCheckBankCardViewController

- (void)bindViewModel
{
    RAC(self.nextView.footerButton,enabled) = [RACSignal combineLatest:@[RACObserve(self, bankCard)] reduce:^id(GGBankCard *bankCard){
        return @(bankCard.idCode.length > 0);
    }];;
    
    @weakify(self);
    [[self.nextView.footerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:NO];
        [self gotoInputNewPhoneVC];
    }];
}

- (void)setupView
{
    self.navigationItem.title = @"验证银行卡";
    [self.baseTableView registerClass:[GGWithdrawCashCardCell class] forCellReuseIdentifier:kCellIdentifierWithdrawCashCell];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.sectionCount = 1;
    self.baseTableView.tableFooterView = self.nextView;
    [self.baseTableView reloadData];
}

- (void)gotoInputNewPhoneVC
{
    GGBingNewPhoneViewController *phoneVC = [[GGBingNewPhoneViewController alloc] initWithBankCard:self.bankCard.idCode];
    [self pushTo:phoneVC];
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
    GGWithdrawCashCardCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierWithdrawCashCell forIndexPath:indexPath];
    [cell showCheckBank:self.bankCard];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.width - 40, 30)];
        textLabel.text = @"选择要验证的银行卡";
        textLabel.font = [UIFont systemFontOfSize:13];
        textLabel.textColor = [UIColor darkGrayColor];
        [view addSubview:textLabel];
        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.bankCard){
        return 80;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        GGMineCardsListViewController *listVC = [[GGMineCardsListViewController alloc] init];
        listVC.cardInfo = ^(GGBankCard *card){
            self.bankCard  = card;
            [self.baseTableView reloadData];
        };
        [self.navigationController pushViewController:listVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (GGFooterView *)nextView
{
    if (!_nextView) {
        _nextView = [[GGFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 88) andFootButtonTitle:@"下一步"];
    }
    return _nextView;
}

@end
