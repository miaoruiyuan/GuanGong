//
//  GGRegisterView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/5/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGRegisterView.h"

@interface GGRegisterView ()<UITextFieldDelegate>

@property(nonatomic,strong)UIView *textFiledBg;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIView *line2;


@end

@implementation GGRegisterView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

    
        [self addSubview:self.textFiledBg];
        [self.textFiledBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(276, 156));
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [self.textFiledBg addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.textFiledBg);
            make.height.mas_equalTo(.6);
            make.top.mas_equalTo(51);
        }];
        
        [self.textFiledBg addSubview:self.line2];
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.textFiledBg);
            make.height.mas_equalTo(.6);
            make.top.equalTo(self.line.mas_bottom).offset(52);
        }];
        
        //手机号
        [self.textFiledBg addSubview:self.userNameFileld];
        [self.userNameFileld mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.textFiledBg.mas_right).with.offset(-8);
            make.left.equalTo(self.textFiledBg).offset(18);
            make.top.equalTo(self.textFiledBg.mas_top).offset(14);
            make.height.mas_equalTo(22);

        }];
        
        //倒计时按钮
        [self.textFiledBg addSubview:self.timerButtton];
        [self.timerButtton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.textFiledBg.mas_right).offset(-8);
            make.centerY.equalTo(self.textFiledBg);
            make.size.mas_equalTo(CGSizeMake(80, 18));
        }];
        
        //验证码
        [self.textFiledBg addSubview:self.identifyCodeFileld];
        [self.identifyCodeFileld mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userNameFileld.mas_left);
            make.right.equalTo(self.timerButtton.mas_left).offset(-10);
            make.height.mas_equalTo(18);
            make.centerY.equalTo(self.timerButtton);
        }];
        
        //密码
        [self.textFiledBg addSubview:self.passwordFileld];
        [self.passwordFileld mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.textFiledBg.mas_right).with.offset(-8);
            make.left.equalTo(self.textFiledBg.mas_left).offset(18);
            make.bottom.equalTo(self.textFiledBg.mas_bottom).offset(-18);
            make.height.mas_equalTo(22);
        }];
        

        //注册按钮
        [self addSubview:self.registerButtton];
        [self.registerButtton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textFiledBg.mas_bottom).offset(16);
            make.centerX.equalTo(self.textFiledBg);
            make.size.mas_equalTo(CGSizeMake(276, 48));
        }];


        //协议
        [self addSubview:self.protocolLabel];
        [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(170, 14));
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-12);
            
        }];

        
    }
    return self;
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

- (UIView *)textFiledBg{
    
    if (!_textFiledBg) {
        _textFiledBg = [[UIView alloc] init];
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

- (UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc]init];
        _line2.backgroundColor = [UIColor colorWithHexString:@"bfbfbf"];
    }
    return _line2;
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
        _passwordFileld.placeholder = @"密码由6-18位数字字母组成";
        _passwordFileld.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _passwordFileld.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordFileld.secureTextEntry = YES;
        _passwordFileld.tintColor = themeColor;
        _passwordFileld.delegate = self;
    }
    return _passwordFileld;
}

- (UITextField *)identifyCodeFileld{
    if (!_identifyCodeFileld) {
        _identifyCodeFileld = [[UITextField alloc] init];
        _identifyCodeFileld.keyboardType = UIKeyboardTypeNumberPad;
        _identifyCodeFileld.textColor = textNormalColor;
        _identifyCodeFileld.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _identifyCodeFileld.clearButtonMode = UITextFieldViewModeWhileEditing;
        _identifyCodeFileld.tintColor = themeColor;
        _identifyCodeFileld.placeholder = @"输入验证码";
    }
    return _identifyCodeFileld;
}

- (UIButton *)timerButtton{
    if (!_timerButtton) {
        _timerButtton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timerButtton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_timerButtton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_timerButtton setTitleColor:textLightColor forState:UIControlStateDisabled];
        [_timerButtton.titleLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightLight]];
    }
    return _timerButtton;
}


- (UIButton *)registerButtton{
    if (!_registerButtton) {
        _registerButtton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButtton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        [_registerButtton setTitleColor :[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerButtton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        [_registerButtton setTitle:@"注册" forState:UIControlStateNormal];
        _registerButtton.layer.masksToBounds = YES;
        _registerButtton.layer.cornerRadius = 6;
    }
    return _registerButtton;
}


- (TTTAttributedLabel *)protocolLabel{
    if (!_protocolLabel) {
        _protocolLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _protocolLabel.font = [UIFont systemFontOfSize:12];
        _protocolLabel.attributedText = [[NSAttributedString alloc] initWithString:@"注册并同意阅读<关二爷协议>" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12 weight:UIFontWeightThin]}];
        _protocolLabel.textAlignment = NSTextAlignmentCenter;
        _protocolLabel.linkAttributes = @{NSForegroundColorAttributeName:TextColor,
                                          NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),
                                          NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular]};
    }
    return _protocolLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
