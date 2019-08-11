
//
//  GGAddCardViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/2.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGAddCardViewController.h"
#import "GGMessageCodeViewController.h"
#import "GGTitleValueCell.h"
#import "GGTextFileldCell.h"
#import "GGPersonalPageRoute.h"
#import "GGFooterView.h"
#import "GGBindCardViewModel.h"
#import "GGAddBankCardItemCell.h"
#import "GGTextFieldButtonCell.h"

@interface GGAddCardViewController ()
{
    NSDictionary *_identifier;
}

@property(nonatomic,strong)GGBindCardViewModel *bindVM;

@property(nonatomic,strong)GGFooterView *footView;

@end

@implementation GGAddCardViewController

- (GGBindCardViewModel *)bindVM
{
    if (!_bindVM) {
        _bindVM = [[GGBindCardViewModel alloc]init];
    }
    return _bindVM;
}

- (void)bindViewModel
{
    
    RAC(self.footView.footerButton,enabled) = self.bindVM.enableBindSignal;
    @weakify(self);
    
    [[self.footView.footerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [MobClick event:@"addbankcardsubmit"];
        [MBProgressHUD showMessage:@"请稍后..."];
        [[self.bindVM.confirmCommand execute:0] subscribeError:^(NSError *error) {
            [MBProgressHUD hideHUD];
        } completed:^{
            @strongify(self);
            [MBProgressHUD showSuccess:@"添加成功" toView:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:GGBindCardSuccessNotification object:nil];
            [self bk_performBlock:^(GGAddCardViewController *obj) {
                [[NSNotificationCenter defaultCenter] postNotificationName:GGUpdataCardListNotification object:nil];
                [MBProgressHUD hideHUDForView:self.view];
                if (obj.popHandler) {
                    obj.popHandler(nil);
                }
                [obj dismiss];
            } afterDelay:1.2];
        }];
    }];

    [RACObserve(self.bindVM, dataSource)subscribeNext:^(id x) {
        @strongify(self);
        [self.baseTableView reloadData];
    }];
}

- (void)setupView
{
    self.navigationItem.title = @"添加银行卡";
    [self.baseTableView registerClass:[GGTextFileldCell class] forCellReuseIdentifier:kCellIdentifierTextField];
    [self.baseTableView registerClass:[GGTitleValueCell class] forCellReuseIdentifier:kCellIdentifierTitleValue];
    [self.baseTableView registerClass:[GGAddBankCardItemCell class] forCellReuseIdentifier:kGGAddBankCardItemCellID];
    [self.baseTableView registerClass:[GGTextFieldButtonCell class] forCellReuseIdentifier:kCellIdentifierTextFieldButton];
    
    _identifier = @{@(GGFormCellTypeNormal):kCellIdentifierTitleValue,
                    @(GGFormCellTypeTitleAndTextField):kGGAddBankCardItemCellID,
                    @(GGFormCellTypeOnlyTextField):kCellIdentifierTextField,
                    @(GGFormCellTypeTextFieldAndButton):kCellIdentifierTextFieldButton};
    
    self.baseTableView.tableFooterView = self.footView;
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.bindVM sectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  [self.bindVM itemCountAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGFormItem *item = [self.bindVM itemForIndexPath:indexPath];
    GGFormBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifier[@(item.cellType)]];
    [cell configItem:item];
    @weakify(self);

    if (indexPath.section == 0){
        if (indexPath.row == 2) {
            GGAddBankCardItemCell *inputCell = (GGAddBankCardItemCell *)cell;
            [[[inputCell.inputTextField rac_textSignal] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString *value) {
                @strongify(self);
                item.obj = self.bindVM.acctId = value;
            }];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            GGTextFileldCell *onlyFiledCell = (GGTextFileldCell *)cell;
            [[onlyFiledCell.textField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString *value) {
                @strongify(self);
                item.obj = self.bindVM.mobilePhone = value;
            }];
        }else if (indexPath.row == 1){
            GGTextFieldButtonCell *btnCell = (GGTextFieldButtonCell *)cell;
            [[btnCell.textField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString *value) {
                @strongify(self);
                item.obj = self.bindVM.messageCode = value;
            }];
            [[[btnCell.sendbutton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:btnCell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
                @strongify(self);
                if (self.bindVM.mobilePhone.length != 11) {
                    [MBProgressHUD showError:@"请输入正确的手机号" toView:self.view];
                    return;
                }
                [self sendIdentifierAction:btn];
            }];
            RAC(btnCell.sendbutton,enabled) = [self.bindVM.enableSendSMSSignal takeUntil:btnCell.rac_prepareForReuseSignal];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:20];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        view.backgroundColor = tableBgColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.width - 20, 30)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = textLightColor;
        label.text = @"请绑定持卡本人的银行卡";
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section == 0) {
        return 30;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     GGFormItem *item = [self.bindVM itemForIndexPath:indexPath];
    
    if (item.pageType == GGPageTypeBanksAddress) {
        if (!self.bindVM.bank.bankName) {
            [MBProgressHUD showError:@"请先选择开户行" toView:self.view];
            return;
        }
        item.obj = self.bindVM.bank.bankCode1;
    }
    
    [GGPersonalPageRoute pushWithItem:item nav:self.navigationController callBack:^(id x) {
        [self.bindVM.reloadData execute:x];
    }];
}

- (GGFooterView *)footView
{
    if (!_footView) {
        _footView = [[GGFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100) andFootButtonTitle:@"完成"];
    }
    return _footView;
}

- (void)sendIdentifierAction:(UIButton *)sender
{
    [sender startCountDown];
    [[self.bindVM.sendIdentifyCommand execute:0] subscribeNext:^(id x) {
        
    } error:^(NSError *error) {
        [sender endTimer];
        [sender setTitle:@"发送验证码" forState:UIControlStateNormal];
    }];
}

@end
