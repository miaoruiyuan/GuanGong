//
//  GGHelperListViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGHelperListViewController.h"
#import "GGHelpQuestionViewModel.h"
#import "GGOnlyLabelCell.h"
#import "GGOneLineTextHeaderView.h"
#import "GGWebViewController.h"
#import "GGFeedbackViewController.h"

@interface GGHelperListViewController ()

@property (nonatomic,strong)GGHelpQuestionViewModel *helpListVM;

@property (nonatomic,strong)UIView *bottonView;

@end

@implementation GGHelperListViewController

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
    self.navigationItem.title = @"使用帮助";
    
    [self.baseTableView registerClass:[GGOnlyLabelCell class] forCellReuseIdentifier:kCellIdentifierOnlyLabel];
    
    [self.baseTableView registerClass:[GGOneLineTextHeaderView class] forHeaderFooterViewReuseIdentifier:kGGOneLineTextHeaderViewID];
    
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    [self.view addSubview:self.bottonView];
    [self.bottonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    self.baseTableView.estimatedRowHeight = 30;
    self.baseTableView.right = UITableViewAutomaticDimension;
}

- (void)bindViewModel
{
    self.helpListVM = [[GGHelpQuestionViewModel alloc] init];
    [MBProgressHUD showMessage:@"正在加载..." toView:self.view];
    @weakify(self);
    [[self.helpListVM.getHelpListCommand execute:nil] subscribeError:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
    } completed:^{
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
        [self.baseTableView reloadData];
    }];
}

#pragma mark -  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.helpListVM itemCountAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGOnlyLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierOnlyLabel forIndexPath:indexPath];
    GGHelpListModel *model = [self.helpListVM itemForIndexPath:indexPath];
    [cell updateHelpListTitle:model.title];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:12];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GGOneLineTextHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGGOneLineTextHeaderViewID];
    [headerView showTitle:@"热点问题"];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GGHelpListModel *model = [self.helpListVM itemForIndexPath:indexPath];
    [self gotoWebView:model];
}

- (void)gotoWebView:(GGHelpListModel *)listModel
{
    GGWebViewController *webVC = [[GGWebViewController alloc] init];
    webVC.url = listModel.url;
    webVC.navigationItem.title = listModel.title;
    [self pushTo:webVC];
}

- (void)gotoFeedBackVC
{
    GGFeedbackViewController *feedbackVC = [[GGFeedbackViewController alloc] init];
    [self pushTo:feedbackVC];
}

#pragma mark - init View

- (UIView *)bottonView
{
    if (!_bottonView) {
        _bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 114, kScreenWidth, 50)];
        UIView *topLineView = [[UIView alloc] init];
        [_bottonView addSubview:topLineView];
        topLineView.backgroundColor = sectionColor;
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_bottonView);
            make.height.mas_equalTo(0.5f);
        }];
        
        UIButton *feedBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [feedBackBtn setImage:[UIImage imageNamed:@"tool_feedback_icon"] forState:UIControlStateNormal];
        [feedBackBtn setTitle:@"  意见反馈" forState:UIControlStateNormal];
        
        [feedBackBtn setTitleColor:[UIColor colorWithHexString:@"737373"] forState:UIControlStateNormal];
        feedBackBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [_bottonView addSubview:feedBackBtn];
        [feedBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_bottonView);
        }];
        
        @weakify(self);
        [[feedBackBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self gotoFeedBackVC];
            [MobClick event:@"advice"];
        }];
    }
    return _bottonView;
}

@end
