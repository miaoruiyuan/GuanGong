//
//  GGNewFriendsViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGNewFriendsViewController.h"
#import "GGFriendInfoViewController.h"
#import "GGAddreeBookViewController.h"
#import "GGMyNewFriendCell.h"
#import "GGMyFriendsViewModel.h"
#import "GGFriendsList.h"
#import "GGTableHeaderFooterView.h"
#import "GGImageViewTitleCell.h"

@interface GGNewFriendsViewController ()

@property(nonatomic,strong)GGMyFriendsViewModel *friensVM;
@property (nonatomic,strong)UILabel *emptyLabel;

@end

@implementation GGNewFriendsViewController

- (void)bindViewModel{

    @weakify(self);
    [self.friensVM.friendNewCommand execute:0];

    [[RACObserve(self.friensVM, dataSource) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        [self.baseTableView reloadData];
        [self showEmptyLabel];
    }];
    RAC(self,emptyDataDisplay) = RACObserve(self.friensVM, isLoading);
    
    //好友添加成功 或 修改备注
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:GGAddFriendSuccessNotification object:nil]subscribeNext:^(id x) {
        @strongify(self);
        [self.friensVM.friendNewCommand execute:0];
    }];
}

- (void)showEmptyLabel
{
    if ([self.friensVM itemCountAtSection:1] > 0) {
        self.emptyLabel.hidden = YES;
        self.emptyLabel.text = @"";
    } else {
        self.emptyLabel.hidden = NO;
        self.emptyLabel.text = self.emptyDataTitle;
    }
}

- (void)setupView{
    self.navigationItem.title = @"新的朋友";
    self.style = UITableViewStylePlain;
    self.emptyDataTitle  = @"暂时没有新的朋友";
    [self.baseTableView registerClass:[GGMyNewFriendCell class] forCellReuseIdentifier:kCellIdentifierMyNewFeiend];
    [self.baseTableView registerClass:[GGImageViewTitleCell class] forCellReuseIdentifier:kCellIdentifierImageViewTitle];
   [self.baseTableView registerClass:[GGTableHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kViewIdentifierHeaderFooterView];
    
//    @weakify(self);
//    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemAdd handler:^(id sender) {
//        @strongify(self);
//        GGAddFriendViewController *addFriendVC = [[GGAddFriendViewController alloc] init];
//        [self pushTo:addFriendVC];
//    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.friensVM sectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.friensVM itemCountAtSection:section];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1 && [self.friensVM itemCountAtSection:section] > 0) {
        GGTableHeaderFooterView *vHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kViewIdentifierHeaderFooterView];
        vHeader.title = @"他们添加了你为兄弟";
        return vHeader;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kLeftPadding];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GGImageViewTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierImageViewTitle];
        cell.imgView.image = [UIImage imageNamed:@"addressBook_contacts"];
        cell.titleLabel.text = [self.friensVM itemForIndexPath:indexPath];
        return cell;
    }
    
    GGMyNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierMyNewFeiend];
    GGFriendsList *friend = [self.friensVM itemForIndexPath:indexPath];
    cell.list = friend;
    
    @weakify(self);
    [[[cell.stateButton rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD showMessage:@"请稍后" toView:self.view];
        [[GGApiManager request_AddAnFriend_WithMobile:friend.mobile formType:AddAnFriendFromAddressBook]subscribeNext:^(id x) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"已添加" toView:self.view];
            [self.friensVM.friendNewCommand execute:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:GGAddFriendSuccessNotification object:nil];
        } error:^(NSError *error) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:self.view];
        }];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 && [self.friensVM itemCountAtSection:section] > 0) {
        return 30;
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0){
        GGAddreeBookViewController *addFriendVC = [[GGAddreeBookViewController alloc] init];
        [self pushTo:addFriendVC];
        return;
    }
    
    GGFriendInfoViewController *friendInfoVC = [[GGFriendInfoViewController alloc]init];
    GGFriendsList *friend = [self.friensVM itemForIndexPath:indexPath];
    friendInfoVC.dealerId = friend.contactId;
    [self pushTo:friendInfoVC];
}

- (GGMyFriendsViewModel *)friensVM{
    if (!_friensVM) {
        _friensVM = [[GGMyFriendsViewModel alloc]init];
    }
    return _friensVM;
}

- (UILabel *)emptyLabel
{
    if (!_emptyLabel) {
        _emptyLabel = [UILabel new];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.font = [UIFont systemFontOfSize:14];
        _emptyLabel.textColor = textLightColor;
        _emptyLabel.frame = CGRectMake(0, (kScreenHeight - 64 - 50)/2 - 20, kScreenWidth, 30);
        [self.baseTableView addSubview:_emptyLabel];
    }
    
    return _emptyLabel;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
