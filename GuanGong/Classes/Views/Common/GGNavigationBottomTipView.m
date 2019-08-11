//
//  GGNavigationBottomTipView.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/12.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGNavigationBottomTipView.h"

@implementation GGNavigationBottomTipView

+ (void)showInNavigation:(UINavigationController *)nav message:(NSString *)message
{
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.frame = CGRectMake(0, 22, kScreenWidth, 42);
    messageLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont systemFontOfSize:15];
    messageLabel.text = message;
    
    [nav.view insertSubview:messageLabel belowSubview:nav.navigationBar];

    CGFloat duration = 0.4;
    [UIView animateWithDuration:duration animations:^{
        messageLabel.transform = CGAffineTransformMakeTranslation(0, messageLabel.height);
    } completion:^(BOOL finished) {
        CGFloat delay = 0.6;
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            messageLabel.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [messageLabel removeFromSuperview];
        }];
    }];
}

@end
