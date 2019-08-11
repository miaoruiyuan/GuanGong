//
//  GGLogInView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/5/24.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGLogInView.h"

@interface GGLogInView ()<UITextFieldDelegate>

@property(nonatomic,strong)UIView *textFiledBg;
@property(nonatomic,strong)UIView *line;
@property(nonatomic, strong) UIImageView * sloganView;

@end

@implementation GGLogInView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.textFiledBg];
        [self.textFiledBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(20);
            make.size.mas_equalTo(CGSizeMake(276, 104));
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [self.textFiledBg addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.textFiledBg);
            make.left.right.equalTo(self.textFiledBg);
            make.height.mas_equalTo(.6);
        }];
        
        
        [self.textFiledBg addSubview:self.userNameFileld];
        [self.userNameFileld mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.textFiledBg.mas_right).with.offset(-8);
            make.left.equalTo(self.textFiledBg).offset(18);
            make.top.equalTo(self.textFiledBg.mas_top).offset(14);
            make.height.mas_equalTo(22);
        }];
        
        
        [self.textFiledBg addSubview:self.passwordFileld];
        [self.passwordFileld mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textFiledBg.mas_left).offset(18);
            make.bottom.equalTo(self.textFiledBg.mas_bottom).offset(-18);
            make.right.equalTo(self.textFiledBg.mas_right).with.offset(-8);
            make.height.mas_equalTo(22);
        }];

        
        [self addSubview:self.logInButton];
        [self.logInButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textFiledBg.mas_bottom).offset(16);
            make.centerX.equalTo(self.textFiledBg);
            make.size.mas_equalTo(CGSizeMake(276, 48));
        }];
        
        [self addSubview:self.forgetButton];
        [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.logInButton.mas_bottom).offset(22);
            make.centerX.equalTo(self.logInButton);
            make.size.mas_equalTo(CGSizeMake(120, 20));
        }];
        
        
        [self addSubview:self.sloganView];
        [self.sloganView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-65);
            make.size.mas_equalTo(CGSizeMake(187, 14));
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        
        
//        _userNameFileld.text = @"13717753997";
//        _passwordFileld.text = @"z123456";

    }
    return self;
}



- (UIView *)textFiledBg{
    
    if (!_textFiledBg) {
        _textFiledBg = [[UIView alloc]init];
        _textFiledBg.backgroundColor = [UIColor whiteColor];
        _textFiledBg.userInteractionEnabled =  YES;
        _textFiledBg.layer.masksToBounds = YES;
        _textFiledBg.layer.cornerRadius = 12.0;
        _textFiledBg.layer.borderWidth = .6;
        _textFiledBg.layer.borderColor = [UIColor colorWithHexString:@"bfbfbf"].CGColor;
    }
    
    return _textFiledBg;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor colorWithHexString:@"bfbfbf"];
    }
    return _line;
}

- (UITextField *)userNameFileld{
    if (!_userNameFileld) {
        _userNameFileld = [[UITextField alloc]init];
        _userNameFileld.textColor = textNormalColor;
        _userNameFileld.placeholder = @"手机号";
        _userNameFileld.keyboardType = UIKeyboardTypeNumberPad;
        _userNameFileld.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _userNameFileld.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameFileld.tintColor = themeColor;

    }
    return _userNameFileld;
}

- (UITextField *)passwordFileld{
    if (!_passwordFileld) {
        _passwordFileld = [[UITextField alloc]init];
        _passwordFileld.textColor = textNormalColor;
        _passwordFileld.placeholder = @"密码";
        _passwordFileld.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _passwordFileld.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordFileld.secureTextEntry = YES;
        _passwordFileld.delegate = self;
        _passwordFileld.tintColor = themeColor;
    }
    return _passwordFileld;
}


- (UIButton *)logInButton{
    if (!_logInButton) {
        _logInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logInButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        [_logInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logInButton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        [_logInButton setTitle:@"登录" forState:UIControlStateNormal];
        _logInButton.layer.masksToBounds = YES;
        _logInButton.layer.cornerRadius = 6;
    }
    return _logInButton;
}


- (UIButton *)forgetButton{
    if (!_forgetButton) {
        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetButton setTitleColor:themeColor forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:13.2 weight:UIFontWeightMedium];
        [_forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetButton setTitleColor:textLightColor forState:UIControlStateHighlighted];
    }
    return _forgetButton;
}

- (UIImageView *)sloganView{
    if (!_sloganView) {
        _sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yypk_slogen"]];
    }
    return _sloganView;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.passwordFileld){
        if (textField.secureTextEntry){
            [textField insertText:self.passwordFileld.text];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
