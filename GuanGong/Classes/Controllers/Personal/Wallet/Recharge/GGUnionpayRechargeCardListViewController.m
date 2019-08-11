//
//  GGUnionpayRechargeCardListViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/7/21.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGUnionpayRechargeCardListViewController.h"
#import "GGBankRechargeViewModel.h"
#import "GGRrechargeOpenCardCell.h"
#import "GGUnionPayWebViewController.h"

@interface GGUnionpayRechargeCardListViewController ()

@property (nonatomic,strong)GGBankRechargeViewModel *rechargeVM;
@property (nonatomic,strong)UIView *footerView;
@property (nonatomic,strong)UIButton *addCardBtn;

@end

@implementation GGUnionpayRechargeCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindViewModel
{
    self.rechargeVM = [[GGBankRechargeViewModel alloc] init];
    [self getOpenCardList];
    
    @weakify(self);
    [[self.addCardBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self gotoAddCardH5View];
    }];
}

- (void)setupView
{
    self.navigationItem.title = @"银行卡充值";
    [self.baseTableView registerClass:[GGRrechargeOpenCardCell class] forCellReuseIdentifier:kGGRrechargeOpenCardCellID];
    self.baseTableView.showsVerticalScrollIndicator = NO;
    self.baseTableView.rowHeight = 66;
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.baseTableView setTableFooterView:self.footerView];
    
    self.view.backgroundColor = self.baseTableView.backgroundColor = [UIColor whiteColor];
}

- (void)getOpenCardList
{
    @weakify(self);
    [[self.rechargeVM.getOpenedCardListCommand execute:nil] subscribeCompleted:^{
        @strongify(self);
        [self.baseTableView reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rechargeVM.cardArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGRrechargeOpenCardCell *cell = [tableView dequeueReusableCellWithIdentifier:kGGRrechargeOpenCardCellID forIndexPath:indexPath];
    [cell showRechargeBankCard:self.rechargeVM.cardArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:12];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GGBankRechargeListModel *card = self.rechargeVM.cardArray[indexPath.row];
    if (self.popHandler) {
        self.popHandler(card);
        [self pop];
    }
}

#pragma mark - init View

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 68)];
        
        self.addCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addCardBtn.layer.masksToBounds = YES;
        self.addCardBtn.layer.cornerRadius = 2;

        self.addCardBtn.layer.borderWidth = 0.5f;
        self.addCardBtn.layer.borderColor = sectionColor.CGColor;
        
        
        [self.addCardBtn setTitleColor:[UIColor colorWithHexString:@"a9a9a9"] forState:UIControlStateNormal];
        [self.addCardBtn setTitle:@"  添加银行卡" forState:UIControlStateNormal];
        [self.addCardBtn setImage:[UIImage imageNamed:@"rechage_add_card"] forState:UIControlStateNormal];
        self.addCardBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_footerView addSubview:self.addCardBtn];
    
        [self.addCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footerView).offset(12);
            make.right.equalTo(_footerView).offset(-12);
            make.top.equalTo(_footerView).offset(12);
            make.height.mas_equalTo(44);
        }];
    }
    return _footerView;
}

@end
