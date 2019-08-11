//
//  GGSetPayPasswordViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGSetPayPasswordViewController.h"
#import "GGConfirmPayPasswordViewController.h"
#import "GGTextFileldCell.h"
#import "GGTextFieldButtonCell.h"
#import "GGFooterView.h"


@interface GGSetPayPasswordViewController ()

@property(nonatomic,strong)RACCommand *sendIdentifyCommand;
@property(nonatomic,strong)GGFooterView *footView;
@property(nonatomic,copy)NSString *iCode;

@end

@implementation GGSetPayPasswordViewController

- (void)bindViewModel{
    RAC(self.footView.footerButton,enabled) = [RACSignal combineLatest:@[RACObserve(self, iCode)] reduce:^id(NSString *number){
        return @(number.length == 6);
    }];
}

- (void)setupView{
    self.navigationItem.title = @"设置支付密码";
    
    [self.baseTableView registerClass:[GGTextFileldCell class] forCellReuseIdentifier:kCellIdentifierTextField];
    [self.baseTableView registerClass:[GGTextFieldButtonCell class] forCellReuseIdentifier:kCellIdentifierTextFieldButton];
    self.baseTableView.tableFooterView = self.footView;
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
    [[self.footView.footerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
        GGConfirmPayPasswordViewController *confirmVC = [[GGConfirmPayPasswordViewController alloc] initWithiCode:_iCode];
        [self pushTo:confirmVC];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        GGTextFileldCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTextField forIndexPath:indexPath];
        cell.textField.text = [GGLogin shareUser].user.mobile;
        cell.textField.enabled = NO;
        return cell;
    } else {
        GGTextFieldButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTextFieldButton forIndexPath:indexPath];
        RAC(self, iCode) = [cell.textField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
        cell.textField.placeholder = @"输入短信验证码";
        @weakify(self);
        [[[cell.sendbutton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
            @strongify(self);
            [self sendIdentifierAction:x];
        }];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:20];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (GGFooterView *)footView{
    if (!_footView) {
        _footView = [[GGFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100) andFootButtonTitle:@"下一步"];
    }
    return _footView;
}
#pragma mark - 发送验证码

- (void)sendIdentifierAction:(UIButton *)sender
{
    [[self.sendIdentifyCommand execute:0] subscribeNext:^(id x) {
        [sender startCountDown];
    } error:^(NSError *error) {
        [sender endTimer];
    }];
}

- (RACCommand *)sendIdentifyCommand
{
    if (!_sendIdentifyCommand) {
        _sendIdentifyCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [[GGApiManager request_IdentifyingCode_WithMobliePhone:[GGLogin shareUser].user.mobile] map:^id(NSString *value) {
                return [RACSignal empty];
            }];
        }];
    }
    return _sendIdentifyCommand;
}

@end
