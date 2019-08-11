//
//  GGPaymentPasscodeView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/27.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPaymentPasscodeView.h"

@interface GGPaymentPasscodeView ()

@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,strong)UIButton *forgetButton;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *line;

@end

@implementation GGPaymentPasscodeView

- (void)bindBtnAction
{
    @weakify(self);
    _codeView.EndEditBlcok = ^(NSString *password,GGPasscodeView *view){
        [view endEdit];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(didEndEditPasswordWithPaymentPassword:)]) {
                [self.delegate didEndEditPasswordWithPaymentPassword:password];
            }
        });
    };
    
    [[_backButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
        [_codeView endEdit];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(didTappedPasswordViewBackButton)]) {
                [self.delegate didTappedPasswordViewBackButton];
            }
        });
        
    }];
    
    
    [[_forgetButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(didTappedPasswordViewForgetPasswordButton)]) {
                [self.delegate didTappedPasswordViewForgetPasswordButton];
            }
        });
    }];
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12,frame.size.width, 28)];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.text = @"输入密码";
            _titleLabel.font = [UIFont systemFontOfSize:18];
            [self addSubview:_titleLabel];
        }
        
        if (!_backButton) {
            _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _backButton.frame = CGRectMake(12, 16, 20, 20);
            [_backButton setImage:[UIImage imageNamed:@"image.bundle/alipay_msp_arrow_left"] forState:UIControlStateNormal];
            [self addSubview:_backButton];
        }
        
        if (!_line) {
            _line = [[UIView alloc]initWithFrame:CGRectMake(0, _backButton.bottom + 20, frame.size.width, .8)];
            _line.backgroundColor = sectionColor;
            [self addSubview:_line];
        }
        
        if (!_codeView) {
            _codeView = [[GGPasscodeView alloc] initWithFrame:
                         CGRectMake(20, 80, frame.size.width - 40, 46)
                                                          num:6
                                                    lineColor:[UIColor lightGrayColor]
                                                     textFont:38];
            
            _codeView.codeType = CodeViewTypeSecret;
            _codeView.hasSpaceLine = YES;
            [self addSubview:_codeView];
        }
        
        if (!_forgetButton) {
            _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _forgetButton.frame = CGRectMake(_codeView.right - 90 , _codeView.bottom + 12, 92, 18);
            [_forgetButton setTitleColor:themeColor forState:UIControlStateNormal];
            [_forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
            _forgetButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:_forgetButton];
        }
        
        [self bindBtnAction];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
