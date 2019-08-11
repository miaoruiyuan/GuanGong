//
//  GGTransferEnterViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTransferEnterViewController.h"
#import "GGSearchUserInfoViewController.h"
#import "GGMyFriendsViewController.h"
#import "GGPaymentOrderRootViewController.h"
#import "GGTransferViewController.h"
#import "GGImageViewTitleCell.h"
#import "GGMyFriendsCell.h"

@interface GGTransferEnterViewController ()

@property(nonatomic,strong)NSArray *lastContacts;

@property(nonatomic,strong)RACCommand *lastContactsCommand;

@end

@implementation GGTransferEnterViewController

- (void)bindViewModel{
    @weakify(self);
    [RACObserve(self, lastContacts) subscribeNext:^(id x) {
        @strongify(self);
        [self.baseTableView reloadData];
    }];
    [self.lastContactsCommand execute:nil];
}

- (void)setupView
{
    self.style = UITableViewStylePlain;
    if (self.isTransfer) {
        self.navigationItem.title = @"转账";
    }else{
        self.navigationItem.title = @"担保支付";
        @weakify(self);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"担保订单" style:UIBarButtonItemStylePlain handler:^(id sender) {
            @strongify(self);
            GGPaymentOrderRootViewController *orderVC = [[GGPaymentOrderRootViewController alloc] init];
            [self pushTo:orderVC];
            [MobClick event:@"Transactiondetail"];
        }];
    }
    
    [self.baseTableView registerClass:[GGMyFriendsCell class] forCellReuseIdentifier:kCellIdentifierMyFeiend];
    [self.baseTableView registerClass:[GGImageViewTitleCell class] forCellReuseIdentifier:kCellIdentifierImageViewTitle];
}

#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
            
        default:
            return self.lastContacts.count;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GGImageViewTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierImageViewTitle];
        switch (indexPath.row) {
            case 0:
                cell.imgView.image = [UIImage imageNamed:@"pay_to_friend"];
                cell.titleLabel.text = @"支付给兄弟";
                break;
                
            default:
                cell.imgView.image = [UIImage imageNamed:@"payment_gg"];
                cell.titleLabel.text = @"支付给关二爷用户";
                break;
        }
        
        return cell;
    } else {
        GGMyFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierMyFeiend];
        GGFriendsList *friendList = self.lastContacts[indexPath.row];
        cell.list = friendList;
        return cell;
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 && self.lastContacts.count > 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        view.backgroundColor = tableBgColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, tableView.width - 20, 30)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = textNormalColor;
        label.text = @"最近";
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 && self.lastContacts.count > 0) {
        return 30;
    }
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:58];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 54;
    }else{
        return 56;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                GGMyFriendsViewController *friendsVC = [[GGMyFriendsViewController alloc]init];
                friendsVC.isTransfer = self.isTransfer;
                [self pushTo:friendsVC];
                if (self.isTransfer) {
                    [MobClick event:@"transfertofriend"];
                }else{
                    [MobClick event:@"paytofriend"];
                }
            }
                break;
                
            default:{
                GGSearchUserInfoViewController *searchUserVC = [[GGSearchUserInfoViewController alloc]init];
                searchUserVC.isTransfer = self.isTransfer;
                [self pushTo:searchUserVC];
                if (self.isTransfer) {
                    [MobClick event:@"transfertouser"];
                }else{
                    [MobClick event:@"paytouser"];
                }
            }
                break;
        }
    }else{
        
        GGFriendsList *friend = self.lastContacts[indexPath.row];
        GGAccount *account = [[GGAccount alloc]init];
        account.realName = friend.realName;
        account.icon = friend.icon;
        account.mobile = friend.mobile;
        account.userId = friend.contactId;
        
        GGTransferViewController *transferVC = [[GGTransferViewController alloc]initWithItem:account];
        transferVC.transferVM.isTransfer = self.isTransfer;
        transferVC.transferVM.isFinalPay = NO;
        [self pushTo:transferVC];
        if (self.isTransfer) {
            [MobClick event:@"transfertorecent"];
        }else{
            [MobClick event:@"paytorecent"];
        }
    }
}

- (RACCommand *)lastContactsCommand{
    if (!_lastContactsCommand) {
        @weakify(self);
        _lastContactsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [[GGApiManager request_LastContacts] map:^id(id value) {
                @strongify(self);
                self.lastContacts = [NSArray modelArrayWithClass:[GGFriendsList class] json:value];
                return [RACSignal empty];
            }];
        }];
    }
   return  _lastContactsCommand;
}

@end
