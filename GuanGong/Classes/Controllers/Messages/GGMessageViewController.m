//
//  GGMessageViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/4/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMessageViewController.h"
#import "GGOtherPayViewController.h"
#import "GGNewFriendsViewController.h"
#import "GGAddFriendViewController.h"
#import "GGImageViewTitleCell.h"

@interface GGMessageViewController ()

@property (nonatomic,strong)UILabel *emptyLabel;

@end

@implementation GGMessageViewController

- (void)bindViewModel
{
    [super bindViewModel];
    
    //好友添加成功通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:GGAddFriendSuccessNotification object:nil]subscribeNext:^(id x) {
        [self.friensVM.loadData execute:0];
    }];
    
    //代付成功
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:GGOtherPaySuccessNotification object:nil] subscribeNext:^(id x) {
        GGOtherPayViewController *otherPayVC = [[GGOtherPayViewController alloc] init];
        [self pushTo:otherPayVC];
    }];
}

- (void)setupView{
    [super setupView];
    self.navigationItem.title = @"兄弟";
    self.emptyDataMessage = @"暂无好友，快去添加好友吧！";
    [self.baseTableView registerClass:[GGImageViewTitleCell class] forCellReuseIdentifier:kCellIdentifierImageViewTitle];
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemAdd handler:^(id sender) {
        @strongify(self);
        GGAddFriendViewController *addFriendVC = [[GGAddFriendViewController alloc]init];
        [self pushTo:addFriendVC];
        [MobClick event:@"addfriend"];
    }];
    
    [RACObserve(self.friensVM, dataSource)subscribeNext:^(id x) {
        @strongify(self);
        [self showEmptyLabel];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.friensVM.dataSource.count > 0) {
        [self.baseTableView reloadData];
    }
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.friensVM sectionCount] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return [self.friensVM itemCountAtSection:section-1];
    }
}

- (void)showEmptyLabel
{
    if ([self.friensVM sectionCount] > 0) {
        self.emptyLabel.hidden = YES;
    }else{
        self.emptyLabel.hidden = NO;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GGImageViewTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierImageViewTitle];
        cell.imgView.image = [UIImage imageNamed:@"addressBook_newFriend"];
        cell.titleLabel.text = @"新的朋友";
        return cell;
    } else {
        GGMyFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierMyFeiend];
        GGFriendsList *friend = [self.friensVM itemForIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section  - 1]];
        cell.list = friend;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GGTableHeaderFooterView *vHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kViewIdentifierHeaderFooterView];
    vHeader.title = self.friensVM.indexTitles[section];
    return vHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }else{
        return 54;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 22;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        GGNewFriendsViewController *newFrienVC = [[GGNewFriendsViewController alloc]init];
        [self pushTo:newFrienVC];
        [MobClick event:@"newfriend"];
        return;
    }
    
    GGFriendInfoViewController *friendInfoVC = [[GGFriendInfoViewController alloc]init];
    GGFriendsList *friendListInfo = [self.friensVM itemForIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1]];
    friendInfoVC.dealerId = friendListInfo.contactId;
    friendInfoVC.friendListInfo = friendListInfo;
    
    [self pushTo:friendInfoVC];
    
    [MobClick event:@"lookatfriend"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UILabel *)emptyLabel
{
    if (!_emptyLabel) {
        _emptyLabel = [UILabel new];
        _emptyLabel.text = self.emptyDataMessage;
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.font = [UIFont systemFontOfSize:14];
        _emptyLabel.textColor = textLightColor;
        _emptyLabel.frame = CGRectMake(0, (kScreenHeight - 64 - 50)/2 - 20, kScreenWidth, 30);
        [self.baseTableView addSubview:_emptyLabel];
    }
    
    return _emptyLabel;
}

@end
