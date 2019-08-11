//
//  GGRevisePasswordViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGRevisePasswordViewController.h"
#import "GGInputOnlyTextPlainCell.h"

@interface GGRevisePasswordViewController ()

@property(nonatomic,copy)NSString *currentPassWord;
@property(nonatomic,copy)NSString *resetPassword;
@property(nonatomic,copy)NSString *resetPasswordConfirm;


@property(nonatomic,strong,readonly)RACCommand *revisePasswordCommand;
@property(nonatomic,strong,readonly)RACCommand *revisePayPasswordCommand;


@end

@implementation GGRevisePasswordViewController

- (void)bindViewModel{
}

- (void)setupView{
    
    if (self.isSetPaymentPassword) {
        self.navigationItem.title = @"修改支付密码";
    }else{
        self.navigationItem.title = @"修改登录密码";
    }
    
    [self.baseTableView registerClass:[GGInputOnlyTextPlainCell class] forCellReuseIdentifier:kCellIdentifierInputOnlyTextPlain];
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"完成" style:UIBarButtonItemStylePlain handler:^(UIBarButtonItem *sender) {
        @strongify(self);
        [self.view endEditing:YES];
        
    
        if (self.isSetPaymentPassword) {
            
            NSString *tipStr = [self changePayPasswordTips];
            if (tipStr) {
                [MBProgressHUD showError:tipStr toView:self.view];
                return;
            }

            
            sender.enabled = NO;
            [[self.revisePayPasswordCommand execute:nil]subscribeError:^(NSError *error) {
                sender.enabled = YES;
            } completed:^{
                sender.enabled = YES;
                [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
                [self bk_performBlock:^(GGRevisePasswordViewController *obj) {
                    [obj pop];
                } afterDelay:1.4];
                
            }];
            
            
        }else{
            
            NSString *tipStr = [self changePasswordTips];
            if (tipStr) {
                [MBProgressHUD showError:tipStr toView:self.view];
                return;
            }
            
            sender.enabled = NO;
            [[self.revisePasswordCommand execute:nil]subscribeError:^(NSError *error) {
                sender.enabled = YES;
            } completed:^{
                sender.enabled = YES;
            
                [UIAlertController alertInController:self
                                               title:nil
                                             message:@"修改密码成功，您需要重新登录哦～"
                                          confrimBtn:@"知道了"
                                        confrimStyle:UIAlertActionStyleDefault
                                       confrimAction:^{
                                           [[GGLogin shareUser] logOut];
                                       }
                                           cancelBtn:nil
                                         cancelStyle:UIAlertActionStyleCancel
                                        cancelAction:nil];

            }];
        }
        
    }];
    
}
 #pragma mark TableM
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 3;
    return row;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGInputOnlyTextPlainCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierInputOnlyTextPlain forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:{
            [cell configWithPlaceholder:@"请输入当前密码" valueStr:self.currentPassWord secureTextEntry:YES];
            cell.textValueChangedBlock = ^(NSString *valueStr){
                self.currentPassWord = valueStr;
            };
        }
            break;
        case 1:{
            [cell configWithPlaceholder:@"请输入新密码" valueStr:self.resetPassword secureTextEntry:YES];
            cell.textValueChangedBlock = ^(NSString *valueStr){
                self.resetPassword = valueStr;
            };
        }
            break;
        default:{
            [cell configWithPlaceholder:@"请确认新密码" valueStr:self.resetPasswordConfirm secureTextEntry:YES];
            cell.textValueChangedBlock = ^(NSString *valueStr){
                self.resetPasswordConfirm = valueStr;
            };
        }
            break;
    }
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:16];
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.isSetPaymentPassword) {
        return @"支付密码为6位数字";
    }
    return @"登录密码至少为6位,数字和字母组合";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}




- (NSString *)changePayPasswordTips{
    NSString *tipStr = nil;
    
    if (![self.currentPassWord isSixNumberPassword]) {
        tipStr = @"6位数字支付密码";
    }else if (![self.resetPassword isSixNumberPassword]){
        tipStr = @"请输入新支付密码";
    }else if (![self.resetPasswordConfirm isSixNumberPassword]){
        tipStr = @"请确认新支付密码";
    }else if (![self.resetPassword isEqualToString:self.resetPasswordConfirm]){
        tipStr = @"两次输入的密码不一致";
    }

    
    return tipStr;
}

- (NSString *)changePasswordTips{
    NSString *tipStr = nil;
    if (!self.currentPassWord || self.currentPassWord.length <= 0){
        tipStr = @"请输入当前密码";
    }else if (!self.resetPassword || self.resetPassword.length <= 0){
        tipStr = @"请输入新密码";
    }else if (!self.resetPasswordConfirm || self.resetPasswordConfirm.length <= 0) {
        tipStr = @"请确认新密码";
    }else if (![self.resetPassword isEqualToString:self.resetPasswordConfirm]){
        tipStr = @"两次输入的密码不一致";
    }else if (self.resetPassword.length < 6){
        tipStr = @"新密码不能少于6位";
    }else if (self.resetPassword.length > 64){
        tipStr = @"新密码不得长于64位";
    }else if (![self.resetPassword validatePassword]){
        tipStr = @"密码必须为数字字母组合";
    }
    return tipStr;
}

#pragma mark - 修改登录密码
- (RACCommand *)revisePasswordCommand{
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        return [[GGApiManager request_RevisePassword_WithResetPassword:self.resetPassword oldPassword:self.currentPassWord]map:^id(id value) {
            
            return [RACSignal empty];
        }];
    }];
}

#pragma mark - 修改支付密码
- (RACCommand *)revisePayPasswordCommand{
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[GGApiManager request_RevisePaymentPassword_WithResetPassword:self.resetPassword oldPassword:self.currentPassWord]map:^id(id value) {
            return [RACSignal empty];
        }];
        
    }];
}





@end
