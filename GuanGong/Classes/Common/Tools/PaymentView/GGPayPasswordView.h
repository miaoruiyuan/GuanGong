//
//  GGPayPasswordView.h
//  PayPassword
//
//  Created by 苗芮源 on 16/8/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPayPasswordView : UIView

@property(nonatomic,copy)void(^inputFinish)(NSString *password,GGPayPasswordView *paymentView);

@property(nonatomic,copy)void(^forgetPassword)(void);

- (id)initWithViewTitle:(NSString *)title;

- (void)showInView:(UIView *)view;
- (void)showProgressViewWithInfoString:(NSString *)infoStr;
- (void)showSuccess:(NSString *)infoStr;

- (void)dismiss;

@end
