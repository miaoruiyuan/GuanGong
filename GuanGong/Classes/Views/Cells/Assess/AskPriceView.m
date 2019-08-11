//
//  AskPriceView.m
//  iautosCar
//
//  Created by 赵三 on 2017/1/3.
//  Copyright © 2017年 iautos_miaoruiyuan. All rights reserved.
//

#import "AskPriceView.h"
#import "UIView+Frame.h"

@interface AskPriceView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *backview;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UITextField *inputTextField;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation AskPriceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        
        _backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _backview.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [self addSubview:_backview];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 2.0;
        _contentView.layer.masksToBounds = YES;
        [_backview addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backview.mas_centerX);
            make.centerY.equalTo(self.backview.mas_centerY);
            make.height.equalTo(@315);
            make.width.equalTo(@315);
        }];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//        [_contentView addGestureRecognizer:tap];
        
        _closeButton  = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"viewclose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(12);
            make.right.equalTo(self.contentView.mas_right).offset(-12);
            make.width.equalTo(@35);
            make.height.equalTo(@35);
        }];
        
//        [[_closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x)
////            if (self.closeBlock) {
////                self.closeBlock();
////            }
//        }];
        
        UILabel *firstLabel = [[UILabel alloc] init];
        firstLabel.font = [UIFont boldSystemFontOfSize:24];
        firstLabel.textColor = [UIColor colorWithHexString:@"c3c3c3"];
        firstLabel.text = @"询价";
        [self.contentView addSubview:firstLabel];
        [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(49);
            make.left.equalTo(self.contentView.mas_left).offset(32);
        }];
        
        self.inputTextField = [[UITextField alloc] init];
        self.inputTextField.font = [UIFont systemFontOfSize:30];
        self.inputTextField.delegate = self;
        self.inputTextField.keyboardType = UIKeyboardTypePhonePad;
        self.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:self.inputTextField];
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(firstLabel.mas_bottom).offset(42);
            make.left.equalTo(self.contentView.mas_left).offset(32);
            make.right.equalTo(self.contentView.mas_right).offset(-32);
            make.height.equalTo(@30);
        }];
       
        NSString *placeHolderText = @"手机号";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:placeHolderText];
        [placeholder addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"c3c3c3"] range:NSMakeRange(0, placeHolderText.length)];
        [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, placeHolderText.length)];
        [placeholder addAttribute:NSBaselineOffsetAttributeName value:@-5 range:NSMakeRange(0, placeHolderText.length)];
        self.inputTextField.attributedPlaceholder = placeholder;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inputTextField.mas_bottom).offset(18);
            make.left.equalTo(self.contentView.mas_left).offset(32);
            make.right.equalTo(self.contentView.mas_right).offset(-32);
            make.height.equalTo(@0.5);
        }];
        
        UILabel *secondLabel = [[UILabel alloc] init];
        secondLabel.font = [UIFont systemFontOfSize:12];
        secondLabel.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        secondLabel.textAlignment = NSTextAlignmentLeft;
        secondLabel.text = @"输入手机号，我们会与您具体交流车辆价格";
        [self.contentView addSubview:secondLabel];
        [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(14);
            make.left.equalTo(self.contentView.mas_left).offset(32);
            make.right.equalTo(self.contentView.mas_right).offset(-32);
        }];
        
        self.submitButton = [[UIButton alloc] init];
        [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.submitButton.backgroundColor = [UIColor colorWithHexString:@"ff8500"];
        self.submitButton.layer.cornerRadius = 2.0;
        self.submitButton.layer.masksToBounds = YES;
        [self.contentView addSubview:self.submitButton];
        [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(secondLabel.mas_bottom).offset(32);
            make.left.equalTo(self.contentView.mas_left).offset(32);
            make.width.equalTo(@245);
            make.height.equalTo(@45);
        }];
        
        @weakify(self);
        [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.inputTextField resignFirstResponder];
            if ([self.inputTextField.text length] == 11) {
//                [self hide];
                if (self.submitButtonBlock) {
                    self.submitButtonBlock(self.inputTextField.text);
                }
            }else{
                [MBProgressHUD showError:@"请输正确的手机号 " toView:self];
            }
        }];
        
    }
    return self;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3f animations:^{
        _contentView.top = 64;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3f animations:^{
        _contentView.centerY = self.centerY;
    } completion:^(BOOL finished) {
        
    }];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location>= 11){
        return NO;
    }else{
        return YES;
    }
}

#pragma mark- 显示和隐藏
-(void)show{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = [win.subviews firstObject];
    [topView addSubview:self];
    [self animationWithView:self.contentView duration:0.5];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputTextField becomeFirstResponder];
    });
}

-(void)hide{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.backgroundColor = [UIColor clearColor];
//    [self removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        _contentView.top = _contentView.height;
        _contentView.height = 0;

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark- 动画
-(void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [view.layer addAnimation:animation forKey:nil];
}



//- (BOOL)valiMobile:(NSString *)mobile
//{
//    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if (mobile.length != 11)
//    {
//        return NO;
//    }else{
//        /**
//         * 手机号码:
//         * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
//         * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
//         * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
//         * 电信号段: 133,149,153,170,173,177,180,181,189
//         */
//        NSString *MOBILE = @"^1(3|4|5|7|8)[0-9]\\d{8}$";
//        
//        NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//        BOOL isMatch4 = [pred4 evaluateWithObject:mobile];
//        
//        if (isMatch4) {
//            return YES;
//        }else{
//            return NO;
//        }
//    }
//}

@end
