//
//  GGInvitationRecordViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGInvitationRecordViewController.h"
#import "GGInvitationRecordViewModel.h"
#import "GGInviteUserInfoCell.h"
#import "GGFriendInfoViewController.h"

@interface GGInvitationRecordViewController ()

@property(nonatomic,strong)UIView *tableHeaderView;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,strong)GGInvitationRecordViewModel *viewModel;

@end

@implementation GGInvitationRecordViewController

- (void)bindViewModel{
    
    self.viewModel = [[GGInvitationRecordViewModel alloc] init];
    @weakify(self);
    [[self.viewModel.loadData.executing skip:1] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.emptyDataDisplay  = !x.boolValue;
    }];
    [self sendRequest];
}

- (void)refreshFooterAction{
    if (self.viewModel.isLoading || !self.viewModel.canLoadMore) {
        [self footerEndNoMoreData];
        return;
    }
    self.viewModel.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest
{
    @weakify(self);
    [[[self.viewModel loadData] execute:0] subscribeError:^(NSError *error) {
        @strongify(self);
        [self.baseTableView setTableHeaderView:nil];
        [self.baseTableView reloadData];
        [self endRefreshHeader];
        [self endRefreshFooter];

    } completed:^{
        @strongify(self);
        if (self.viewModel.dataSource.count > 0) {
            [self.baseTableView setTableHeaderView:self.tableHeaderView];
            self.countLabel.text = [NSString stringWithFormat:@"%ld",[self.viewModel.totalCount longValue]];
        }else{
            [self.baseTableView setTableHeaderView:nil];
        }
        [self.baseTableView reloadData];
        [self endRefreshHeader];
        [self endRefreshFooter];
        self.baseTableView.mj_footer.hidden = self.viewModel.dataSource.count < [self.viewModel.totalCount longValue] ? NO : YES;
    }];
}

- (void)setupView
{
    self.navigationItem.title = @"我的邀请";
 
    self.emptyDataTitle = @"您还没有邀请过任何人";
    
    [self.baseTableView registerClass:[GGInviteUserInfoCell class] forCellReuseIdentifier:NSStringFromClass([GGInviteUserInfoCell class])];
    
    self.enabledRefreshFooter = YES;
}


#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataSource.count;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGInviteUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GGInviteUserInfoCell class])];
    GGInvite *inviteModel = self.viewModel.dataSource[indexPath.row];
    [cell updateUIWithModel:inviteModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GGInvite *inviteModel = self.viewModel.dataSource[indexPath.row];
    GGFriendInfoViewController *friendInfoVC = [[GGFriendInfoViewController alloc] init];
    friendInfoVC.dealerId = inviteModel.userId;
    [self pushTo:friendInfoVC];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && self.viewModel.dataSource.count > 0) {
        return 30;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 && self.viewModel.dataSource.count > 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.width - 20, 30)];
        titleLabel.text = @"已邀请好友";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = textNormalColor;
        
        [view addSubview:titleLabel];
        return view;
    }
    return nil;
}

#pragma mark - 邀请好友

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.baseTableView.width, 140)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        UILabel *countLabel = [[UILabel alloc] init];
        countLabel.backgroundColor = themeColor;
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.textColor = [UIColor whiteColor];
        countLabel.font = [UIFont systemFontOfSize:30];
        countLabel.layer.masksToBounds = YES;
        countLabel.layer.cornerRadius = 30;
        
        self.countLabel = countLabel;

        [_tableHeaderView addSubview:countLabel];
        
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_tableHeaderView);
            make.centerY.equalTo(_tableHeaderView).offset(-16);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.text = @"已邀请人数";
        desLabel.textAlignment = NSTextAlignmentCenter;
        desLabel.textColor = textLightColor;
        desLabel.font = [UIFont systemFontOfSize:15];
        [_tableHeaderView addSubview:desLabel];

        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_tableHeaderView);
            make.top.equalTo(countLabel.mas_bottom).offset(15);
        }];
    }
    return _tableHeaderView;
}


@end
