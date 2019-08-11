//
//  GGOrderDepositAlertView.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/8.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGOrderDepositAlertView : UIView

+ (instancetype)showContent:(NSString *)content andBlock:(void(^)())block;

@end
