//
//  GGPaymentCodeView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPaymentCodeView.h"
#import "GGPaymentPasscodeView.h"
#import "GGPaymentResultView.h"

static const CGFloat paymentViewH = 386;
@interface GGPaymentCodeView ()<GGPaymentCodeViewDelegate,GGPaymentResultViewDelegate>

@property(nonatomic, strong)UIView *bgView;
@property(nonatomic,strong)GGPaymentPasscodeView *paymentPasscodeView;
@property(nonatomic,strong)GGPaymentResultView *paymentResultView;



@end

@implementation GGPaymentCodeView

- (void)show
{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.frame = [[UIScreen mainScreen] bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth * 2, paymentViewH)];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    
    // 密码输入视图
    self.paymentPasscodeView = [[GGPaymentPasscodeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.bgView.height)];
    self.paymentPasscodeView.delegate = self;
    [self.bgView addSubview:self.paymentPasscodeView];
    
    // 付款结果视图
    self.paymentResultView = [[[NSBundle mainBundle] loadNibNamed:@"GGPaymentResultView" owner:nil options:nil] lastObject];
    self.paymentResultView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth,self.bgView.height);
    self.paymentResultView.delegate = self;
    [self.bgView addSubview:self.paymentResultView];
    
    
    // 动画弹出详情视图    
    [UIView animateWithDuration:.25 animations:^{
        self.bgView.transform = CGAffineTransformTranslate(self.bgView.transform, 0, -self.bgView.height);
    } completion:^(BOOL finished) {
        [self.paymentPasscodeView.codeView beginEdit];
    }];
    
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.transform = CGAffineTransformTranslate(self.bgView.transform, 0, self.bgView.height);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)paymentResult:(BOOL)result message:(NSString *)message{
    self.paymentResultView.confirmButton.enabled = YES;
    self.paymentResultView.confirmButton.backgroundColor = themeColor;
    
    if (result) {
        // 显示成功UI
        self.paymentResultView.resultLabel.text = message;
        [self.paymentResultView.loadView loadStatus:GGLoadStatusSuccess];
    } else {
        // 显示失败UI
        self.paymentResultView.resultLabel.text = message;
        [self.paymentResultView.loadView loadStatus:GGLoadStatusFailed];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([message isEqualToString:@"当前支付密码不正确"]) {
                
                [UIAlertController alertInController:[[[UIApplication sharedApplication] keyWindow] rootViewController]
                                               title:@"付款失败"
                                             message:message
                                          confrimBtn:@"重新输入"
                                        confrimStyle:UIAlertActionStyleDefault
                                       confrimAction:^{
                                           // 重新输入
                                           [UIView animateWithDuration:0.25 animations:^{
                                               self.bgView.transform = CGAffineTransformTranslate(self.bgView.transform, kScreenWidth, 0);
                                           } completion:^(BOOL finished) {
                                               [self.paymentPasscodeView.codeView endEdit];
                                           }];
                                       }
                                           cancelBtn:@"取消"
                                         cancelStyle:UIAlertActionStyleCancel
                                        cancelAction:^{
                                            // 取消
                                            [self dismiss];
                                            if ([self.delegate respondsToSelector:@selector(paymentComplete)]) {
                                                [self.delegate paymentComplete];
                                            }
                                        }];
                
                
                
                
            }
        });
        
    }

}

#pragma mark -GGPaymentCodeViewDelegate
- (void)didEndEditPasswordWithPaymentPassword:(NSString *)paymentPassword{
    [self.paymentResultView.loadView cleanLayer];
    self.paymentResultView.resultLabel.text = @"正在付款...";
    [self.paymentResultView.loadView loadStatus:GGLoadStatusLoading];
    
//    // 动画偏移视图，显示出支付详情视图
//    [UIView animateWithDuration:0.25 animations:^{
//        self.bgView.transform = CGAffineTransformTranslate(self.bgView.transform, -kScreenWidth, 0);
//    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 回调支付密码
        if ([self.delegate respondsToSelector:@selector(didTappedConfirmButtonWithpaymentPassword:)]) {
            [self.delegate didTappedConfirmButtonWithpaymentPassword:paymentPassword];
        }
    });

}
- (void)didTappedPasswordViewBackButton
{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(didTappedColseButton)]) {
        [self.delegate didTappedColseButton];
    }
}

- (void)didTappedPasswordViewForgetPasswordButton{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(didTappedForgetPasswordButton)]) {
        [self.delegate didTappedForgetPasswordButton];
    }

}

#pragma mark -GGPaymentResultViewDelegate

- (void)didTappedResultViewConfirmButton
{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(paymentComplete)]) {
        [self.delegate paymentComplete];
    }
}

- (void)didTappedResultViewBackButton{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.transform = CGAffineTransformTranslate(self.bgView.transform, kScreenWidth, 0);
    } completion:^(BOOL finished) {
        [self.paymentPasscodeView.codeView beginEdit];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
