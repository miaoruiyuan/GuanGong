//
//  GGRechageListViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/7/18.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGRechageListViewController.h"
#import "GGCapitalClearApplyViewController.h"

#import "GGRechargeViewController.h"
#import "GGUnionpayRechargeViewController.h"

#import "GGBankRechargeViewModel.h"
#import "GGRechageListCell.h"

@interface GGRechageListViewController ()

@property (nonatomic,strong)UIButton *clearButton;
@property (nonatomic,strong)GGBankRechargeViewModel *rechargeVM;

@end

@implementation GGRechageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView
{
    self.view.backgroundColor = tableBgColor;
 
    self.navigationItem.title = @"充值";

    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.bottom.equalTo(self.view).offset(-120);
    }];
    
    [self.view addSubview:self.clearButton];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 32));
        make.top.equalTo(self.baseTableView.mas_bottom).offset(10);
    }];
    
    [self.baseTableView registerClass:[GGRechageListCell class] forCellReuseIdentifier:kGGRechageListCellID];
    self.baseTableView.estimatedRowHeight = self.baseTableView.rowHeight = 142;
}

- (void)bindViewModel{

    self.rechargeVM = [[GGBankRechargeViewModel alloc] init];
    
    @weakify(self);

    [[self.rechargeVM.getChargeRateCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.baseTableView reloadData];
    }];
    

    [[self.clearButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        GGCapitalClearApplyViewController *clearVC = [[GGCapitalClearApplyViewController alloc] init];
        [[self class] presentVC:clearVC];
        [MobClick event:@"notaccount"];
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.rechargeVM.rateModel) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GGRechageListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGGRechageListCellID forIndexPath:indexPath];
    if (cell) {
        if (indexPath.section == 0) {
            [cell updateUIWithModel:self.rechargeVM.rateModel];
        }else{
            [cell updateUIWithModel:nil];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && self.rechargeVM.rateModel) {
        GGUnionpayRechargeViewController *rechargeVC = [[GGUnionpayRechargeViewController alloc] initWithViewModel:self.rechargeVM];
        [self pushTo:rechargeVC];
    }else{
        GGRechargeViewController *rechargeVC = [[GGRechargeViewController alloc] init];
        [self pushTo:rechargeVC];
    }
    
}

#pragma mark - init view

- (UIButton *)clearButton{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearButton setTitleColor:themeColor forState:UIControlStateNormal];
        [_clearButton setTitle:@"充值未到账?" forState:UIControlStateNormal];
        _clearButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _clearButton.backgroundColor  = tableBgColor;
    }
    return _clearButton;
}

@end
