//
//  GGMessageCodeViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/20.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMessageCodeViewController.h"
#import "GGRechargeLodingViewController.h"

@interface GGMessageCodeViewController ()

@property(nonatomic,strong)UILabel *tipsLabel;
@property(nonatomic,strong)UIView *textFieldBg;

@property(nonatomic,strong)UITextField *codeFiled;
@property(nonatomic,strong)UIButton *timerButton;

@property(nonatomic,strong)UIButton *sureButton;

@end

@implementation GGMessageCodeViewController

- (void)bindViewModel
{
    @weakify(self);
    RAC(self.sureButton,enabled) = [RACSignal combineLatest:@[self.codeFiled.rac_textSignal]
                                                     reduce:^id(NSString *value){
                                                         return @(value.length >= 4 && value.length <= 7 );
                                                     }];
    //确定
    [[self.sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.withDrawVM) {
            [self handelDrawVM];
        } else if (self.bindCardVM) {
            [self handelBindCardVM];
        } else if (self.rechargeVM){
            [self handelRechargeVM];
        }
    }];
    
    //发送验证码
    [[self.timerButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *button) {
        @strongify(self);
        if (self.bindCardVM) {
            [[self.bindCardVM.sendIdentifyCommand execute:nil]subscribeNext:^(id x) {
                @strongify(self);
                [MBProgressHUD showSuccess:@"发送成功,注意查收" toView:self.view];
                [self bk_performBlock:^(id obj) {
                    [self.timerButton startCountDown];
                } afterDelay:1.0];
            } error:^(NSError *error) {
                @strongify(self);
                [self.timerButton endTimer];
                [MBProgressHUD showError:@"短信动态码验证中" toView:self.view];
            }];
            return;
        }else if (self.rechargeVM){
            if (self.rechargeVM.password) {
                [[self.rechargeVM.sendPaySMSCommand execute:self.rechargeVM.password] subscribeNext:^(id x) {
                    @strongify(self);
                    [MBProgressHUD showSuccess:@"发送成功,注意查收" toView:self.view];
                    [self bk_performBlock:^(id obj) {
                        [self.timerButton startCountDown];
                    } afterDelay:0.5f];
                } error:^(NSError *error) {
                    @strongify(self);
                    [self.timerButton endTimer];
                }];
            }
            return;
        }
    }];
}

- (void)setupView
{
    self.navigationItem.title = @"验证身份";
    self.view.backgroundColor = tableBgColor;
    
    [self.view addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(86);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(15);
    }];

    [self.view addSubview:self.textFieldBg];
    [self.textFieldBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
    }];
    
    //转账不需要倒计时按钮
    if (self.withDrawVM) {
        [self.textFieldBg addSubview:self.codeFiled];
        [self.codeFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textFieldBg.mas_left).offset(18);
            make.centerY.equalTo(self.textFieldBg);
            make.height.mas_equalTo(22);
            make.right.equalTo(self.textFieldBg.mas_right).offset(-20);
        }];
    } else {
        [self.textFieldBg addSubview:self.timerButton];
        [self.timerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.textFieldBg.mas_right).offset(-10);
            make.centerY.equalTo(self.textFieldBg);
            make.size.mas_equalTo(CGSizeMake(80, 22));
        }];
        
        [self.textFieldBg addSubview:self.codeFiled];
        [self.codeFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textFieldBg.mas_left).offset(18);
            make.centerY.equalTo(self.textFieldBg);
            make.height.mas_equalTo(22);
            make.right.equalTo(self.timerButton.mas_left).offset(-20);
        }];
    }
    
    [self.view addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.textFieldBg.mas_bottom).offset(30);
        make.height.mas_equalTo(40);
    }];
    
    if (self.bindCardVM) {
        self.tipsLabel.text = [NSString stringWithFormat:@"点击向的手机号%@发送验证码",[self.bindCardVM.mobilePhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
    }else if (self.withDrawVM){
        self.tipsLabel.text = [NSString stringWithFormat:@"已向手机尾号%@发送了验证码,注意查收",self.withDrawVM.phoneLast4Code];;
    }else if (self.rechargeVM){
        [self.timerButton startCountDown];
        self.tipsLabel.text = [NSString stringWithFormat:@"请输入手机号%@收到的验证码",self.rechargeVM.defaultBankModel.telephone];
    }
}

- (void)handelDrawVM
{
    self.withDrawVM.messageCode = self.codeFiled.text;
    
    [MBProgressHUD showMessage:@"处理中..."];
    
    @weakify(self);
    [[self.withDrawVM.doneCommand execute:0]subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD showSuccess:@"提现成功" toView:self.view];
        [self bk_performBlock:^(GGMessageCodeViewController *obj) {
            [obj.navigationController popToRootViewControllerAnimated:YES];
        } afterDelay:1.0];
    } completed:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:GGTransferSuccessNotification object:nil];
    }];
}

- (void)handelBindCardVM
{
    self.bindCardVM.messageCode = self.codeFiled.text;
    [MBProgressHUD showMessage:@"请稍后..."];
    
    @weakify(self);
    [[self.bindCardVM.confirmCommand execute:0] subscribeCompleted:^{
        @strongify(self);
        [MBProgressHUD showSuccess:@"充值成功" toView:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:GGBindCardSuccessNotification object:nil];
        [self bk_performBlock:^(GGMessageCodeViewController *obj) {
            [obj.navigationController popToRootViewControllerAnimated:YES];
        } afterDelay:1.2];
    }];
}

- (void)handelRechargeVM
{
    [MBProgressHUD showMessage:@"请稍后..."];
    @weakify(self);
    [[self.rechargeVM.paySMSConfirmCommand execute:self.codeFiled.text] subscribeCompleted:^{
        @strongify(self);
        [MBProgressHUD showSuccess:@"验证成功" toView:self.view];
        [self bk_performBlock:^(GGMessageCodeViewController *obj) {
            GGRechargeLodingViewController *lodingVC = [[GGRechargeLodingViewController alloc] initWithOrderNo:self.rechargeVM.payOrderNO];
            [lodingVC setPopHandler:self.popHandler];
            [obj pushTo:lodingVC];
        } afterDelay:0.5f];
    }];
}

#pragma mark - init View

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel= [[UILabel alloc] init];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        _tipsLabel.textColor = textNormalColor;
    }
    return _tipsLabel;
}

- (UIView *)textFieldBg
{
    if (!_textFieldBg) {
        _textFieldBg = [[UIView alloc] init];
        _textFieldBg.backgroundColor = [UIColor whiteColor];
    }
    return _textFieldBg;
}

- (UITextField *)codeFiled{
    if (!_codeFiled) {
        _codeFiled = [[UITextField alloc] init];
        _codeFiled.placeholder = @"短信校验码";
        _codeFiled.font = [UIFont systemFontOfSize:16];
        _codeFiled.keyboardType = UIKeyboardTypeNumberPad;
        _codeFiled.textColor = textNormalColor;
    }
    return _codeFiled;
}

- (UIButton *)timerButton{
    if (!_timerButton) {
        _timerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timerButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_timerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_timerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_timerButton.titleLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightLight]];
        [_timerButton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        _timerButton.layer.masksToBounds = YES;
        _timerButton.layer.cornerRadius = 3.0;
    }
    return _timerButton;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 2;
    }
    return _sureButton;
}

@end
