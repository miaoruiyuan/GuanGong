
//
//  GGPayPasswordView.m
//  PayPassword
//
//  Created by 苗芮源 on 16/8/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GGPayPasswordView.h"
#import "GGPasswordView.h"
#import "GGPayAnimationView.h"

@interface GGPayPasswordView ()

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *coverView;
@property(nonatomic,strong)GGPasswordView *codeView;
@property(nonatomic,strong)UITextField *inputField;
@property(nonatomic,strong)UIButton *cancelButton;
@property(nonatomic,strong)UIButton *forgetButton;

@property(nonatomic,strong)GGPayAnimationView *animationView;


@property(nonatomic,copy)NSString *password;

@end


static CGFloat CoverViewHeight = 450;

@implementation GGPayPasswordView
- (id)initWithViewTitle:(NSString *)title{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.alpha=0;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        
        [self addSubview:self.coverView];
        [self.coverView addSubview:self.animationView];
        [self addSubview:self.inputField];
        
        [self.inputField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.forgetButton addTarget:self action:@selector(forgetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.titleLabel.text = title;
        
    }
    return self;
}


- (void)showInView:(UIView *)view{
    [view addSubview:self];
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.coverView.transform = CGAffineTransformMakeTranslation(0,-CoverViewHeight);
        self.alpha++;
    } completion:^(BOOL finished) {
        [self.inputField becomeFirstResponder];
    }];

}



- (void)dismiss{
    [self performSelectorOnMainThread:@selector(cancelButtonAction:) withObject:self waitUntilDone:NO];
}

- (void)textValueChanged:(UITextField *)textField{
    
    if (textField.text.length < self.password.length) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GGKeyboardDeleteButtonClick object:self];
    }else{
        
        if (textField.text.length == 6) {
            if (self.inputFinish) {
                self.inputFinish(textField.text,self);
                self.password = nil;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:GGlenKeyboardNumberButtonClick object:self userInfo:@{GGlenKeyboardNumberKey : textField.text}];

    }
    
    self.password = textField.text;
}


- (void)showProgressViewWithInfoString:(NSString *)infoStr{

    [UIView animateWithDuration:.35 animations:^{
        self.codeView.hidden = YES;
        self.animationView.hidden = NO;
        self.forgetButton.hidden = YES;
        [self.inputField endEditing:NO];
    } completion:^(BOOL finished) {
        __weak typeof(self) weakSelf=self;
        [self.animationView showProgressView:infoStr stopAnimation:^(BOOL isFinish) {
            [weakSelf dismiss];
        }];
    }];
    
}

- (void)showSuccess:(NSString *)infoStr{
    [self.animationView showSuccess:infoStr];
}

#pragma mark- 点击取消
- (void)cancelButtonAction:(UIButton *)sender{
    [self hiddenKeyBoard:^(BOOL finished) {
        [self.codeView setNeedsDisplay];
        [self removeFromSuperview];
    }];
}
#pragma mark- 点击忘记密码
- (void)forgetButtonAction:(UIButton *)sender{
    if (self.forgetPassword) {
        self.forgetPassword();
    }
}

#pragma mark - 键盘关闭
- (void)hiddenKeyBoard:(void (^)(BOOL finished))completion{
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.coverView.transform = CGAffineTransformMakeTranslation(0,0);
        self.alpha--;
        [self.inputField resignFirstResponder];
        
    } completion:completion];
}




- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.frame),CGRectGetWidth(self.frame) , CoverViewHeight)];
        _coverView.backgroundColor = [UIColor whiteColor];
        [_coverView addSubview:self.titleLabel];
        [_coverView addSubview:self.codeView];
        [_coverView addSubview:self.cancelButton];
        [_coverView addSubview:self.forgetButton];
    }
    return _coverView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, CGRectGetWidth(self.frame), 30)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (GGPasswordView *)codeView{
    if (!_codeView) {
        _codeView = [[GGPasswordView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame)+10,  CGRectGetWidth(self.frame), 60)];
    }
    return _codeView;
}

- (UITextField *)inputField{
    if (!_inputField) {
        _inputField = [[UITextField alloc] init];
        _inputField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _inputField;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(14, 16, 14, 14);
        [_cancelButton setImage:[UIImage imageNamed:@"trade.bundle/zhifu-close"] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (UIButton *)forgetButton{
    if (!_forgetButton) {
        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetButton.frame = CGRectMake(CGRectGetMaxX(self.codeView.frame)-90, CGRectGetMaxY(self.codeView.frame)+10, 70, 40);
        [_forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetButton.titleLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightLight]];
        [_forgetButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }
    return _forgetButton;
}

- (GGPayAnimationView *)animationView{
    if (!_animationView) {
        _animationView = [[GGPayAnimationView alloc] init];
        _animationView.center = CGPointMake(CGRectGetWidth(self.coverView.frame)/2, 120);
        _animationView.hidden = YES;
    }
    return _animationView;
}







@end
