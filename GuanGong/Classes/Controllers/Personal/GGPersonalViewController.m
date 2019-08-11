//
//  GGPersonalViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/4/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPersonalViewController.h"
#import "GGMineInfoView.h"
#import "GGAttestationViewController.h"
#import "GGCarsOrderManagementViewController.h"
#import "GGMineInfoViewController.h"
#import "GGSettingViewController.h"
#import "GGWalletViewController.h"
#import "GGInviteViewController.h"
#import "GGPersonItemCell.h"
#import "GGPersonalViewModel.h"
#import "GGAboutViewController.h"
#import "GGHelperListViewController.h"
#import "GGMessageListViewController.h"

@interface GGPersonalViewController (){
    NSDictionary *_identifier;
}
@property(nonatomic,strong)GGMineInfoView *mineInfoView;
@property(nonatomic,strong)GGPersonalViewModel *personalVM;


@end

@implementation GGPersonalViewController

- (GGPersonalViewModel *)personalVM{
    if (!_personalVM) {
        _personalVM = [[GGPersonalViewModel alloc]init];
    }
    return _personalVM;
}

- (void)setupView
{
    self.style = UITableViewStylePlain;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationItem.title = @"我的";
//    
    @weakify(self);
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"car_history_time_icon"] style:UIBarButtonItemStylePlain handler:^(id sender) {
//        @strongify(self);
//        GGMessageListViewController *messageVC = [[GGMessageListViewController alloc] init];
//        [self pushTo:messageVC];
//    }];
    
    [self.baseTableView registerClass:[GGPersonItemCell class] forCellReuseIdentifier:kCellIdentifierPersonItem];
    self.baseTableView.tableHeaderView = self.mineInfoView;
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
    }];
    _identifier = @{@(GGFormCellTypeNormal):kCellIdentifierPersonItem};
    
    [self.mineInfoView bk_whenTapped:^{
        @strongify(self);
        GGMineInfoViewController *mineInfoVC = [[GGMineInfoViewController alloc]init];
        [self pushTo:mineInfoVC];
        [MobClick event:@"personalinformation"];
    }];
}

- (void)bindViewModel{
    @weakify(self);
    [RACObserve(self.personalVM, dataSource)subscribeNext:^(id x) {
        @strongify(self);
        [self.baseTableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mineInfoView layoutSubviews];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.personalVM sectionCount];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.personalVM itemCountAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGFormItem *item = [self.personalVM itemForIndexPath:indexPath];
    GGPersonItemCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifier[@(item.cellType)]];
    [cell configItem:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kLeftPadding hasSectionLine:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    if (![self checkRealNameAuthentication]) {
                        GGAttestationViewController *attVC = [[GGAttestationViewController alloc]init];
                        attVC.showNoCheckTipView = YES;
                        [self pushTo:attVC];
                        return ;
                    }
                    
                    GGWalletViewController *walletVC = [[GGWalletViewController alloc]init];
                    [self pushTo:walletVC];
                    [MobClick event:@"wallet"];
                }
                    break;
            }
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    GGInviteViewController *inviteVC = [[GGInviteViewController alloc]init];
                    [self pushTo:inviteVC];
                    [MobClick event:@"invitation"];
                }
                    break;
                case 1:{
                    GGHelperListViewController *helpVC = [[GGHelperListViewController alloc] init];
                    [self pushTo:helpVC];
                    [MobClick event:@"help"];
                }
                    break;
                case 2:{
                    GGAboutViewController *aboutVC = [[GGAboutViewController alloc] init];
                    [self pushTo:aboutVC];
                }
                    break;
                case 3:{
                    NSString *str= [[NSString alloc] initWithFormat:@"tel:%@",@"4008220063"];
                    UIWebView *callWebview = [[UIWebView alloc] init];
                    [self.view addSubview:callWebview];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    [MobClick event:@"update"];
                }
                    break;
            }
            break;
        }
        default:{
            switch (indexPath.row) {
                case 0:{
                    GGSettingViewController *settingVC = [[GGSettingViewController alloc]init];
                    [self pushTo:settingVC];
                }
                break;
            }
        }
    }
}


- (GGMineInfoView *)mineInfoView{
    if (!_mineInfoView) {
        _mineInfoView = [[GGMineInfoView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 140)];
    }
    return _mineInfoView;
}

@end
