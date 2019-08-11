//
//  GGFriendMoreSetViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFriendMoreSetViewController.h"
#import "GGInputViewController.h"
#import "GGFooterView.h"
#import "GGFriendInfoViewController.h"
#import "GGFriendBillListViewController.h"

@interface GGFriendMoreSetViewController ()

@property(nonatomic,strong)GGFooterView *footerView;

@property(nonatomic,strong,readonly)RACCommand *setFriendRemark;
@property(nonatomic,strong,readonly)RACCommand *deleteFriend;

@end

@implementation GGFriendMoreSetViewController

- (void)bindViewModel{
    
    @weakify(self);
    [[self.footerView.footerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [UIAlertController alertInController:self
                                       title:@"确定要删除此好友?"
                                     message:nil
                                  confrimBtn:@"确定"
                                confrimStyle:UIAlertActionStyleDefault
                               confrimAction:^{
                                   @strongify(self);
                                   [MBProgressHUD showMessage:@"请稍后" toView:self.view];
                                   [[self.deleteFriend execute:nil] subscribeError:^(NSError *error) {
                                       @strongify(self);
                                       [MBProgressHUD hideHUDForView:self.view];
                                   } completed:^{
                                       @strongify(self);
                                       [MBProgressHUD hideHUDForView:self.view];
                                       [MBProgressHUD showSuccess:@"删除好友成功" toView:self.view];
                                       [[NSNotificationCenter defaultCenter] postNotificationName:GGAddFriendSuccessNotification object:nil];
                                       [self bk_performBlock:^(GGFriendMoreSetViewController *obj) {
                                           [obj.navigationController popToRootViewControllerAnimated:YES];
                                       } afterDelay:1.0];
                                   }];
                                   
                               }
                                   cancelBtn:@"取消"
                                 cancelStyle:UIAlertActionStyleCancel
                                cancelAction:nil];
    }];
}

- (void)setupView{
    self.navigationItem.title = @"更多";
    self.baseTableView.tableFooterView = self.footerView;
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UITableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = textNormalColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"设置备注";
        cell.detailTextLabel.text = self.friendInfo.remark;
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"交易记录";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            GGFormItem *item = [[GGFormItem alloc] init];
            item.title = @"备注";
            GGPersonalInput *content = [[GGPersonalInput alloc] init];
            content.placeholder = @"填写备注信息";
            item.pageContent = content;
            item.obj = self.friendInfo.remark;
            [self editFriendRemark:item];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            GGFriendBillListViewController *vc = [[GGFriendBillListViewController alloc] init];
            vc.otherUserID = [self.friendInfo.userId stringValue];
            [self pushTo:vc];
        }
    }
}

- (void)editFriendRemark:(GGFormItem *)item
{
    GGInputViewController *inputVC = [[GGInputViewController alloc] initWithItem:item];
    @weakify(self);
    inputVC.popHandler = ^(GGFormItem *value){
        @strongify(self);
        self.friendInfo.remark  = value.obj;
        [self.baseTableView reloadData];
        [MBProgressHUD showMessage:@"修改中..." toView:self.view];
        [[self.setFriendRemark execute:value.obj] subscribeError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
        } completed:^{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"设置成功" toView:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:GGAddFriendSuccessNotification object:nil];
        }];
    };
    [self pushTo:inputVC];
}

#pragma mark -

- (GGFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[GGFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100) andFootButtonTitle:@"删除好友"];
    }
    return _footerView;
}

- (RACCommand *)deleteFriend{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[GGApiManager request_DeleteAnFriend_WithContactId:self.friendInfo.contactId] map:^id(NSString *value) {
            
            return [RACSignal empty];
        }];
    }];
}

- (RACCommand *)setFriendRemark{
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSString *input) {
        return [[GGApiManager request_EditFriendInfo_WithContactId:self.friendInfo.contactId remark:input]map:^id(id value) {
            
            return [RACSignal empty];
        }];
    }];
}

@end
