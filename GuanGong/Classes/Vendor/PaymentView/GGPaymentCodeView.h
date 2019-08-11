//
//  GGPaymentCodeView.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGPaymentCodeDelegate <NSObject>

@required

- (void)didTappedConfirmButtonWithpaymentPassword:(NSString *)paymentPassword;

@optional

- (void)didTappedColseButton;
- (void)didTappedForgetPasswordButton;
- (void)paymentComplete;

@end

@interface GGPaymentCodeView : UIView

@property (nonatomic, weak) id<GGPaymentCodeDelegate> delegate;

/**
 *  付款结果
 *
 *  @param result YES为成功
 *  @param message 提示信息
 */
- (void)paymentResult:(BOOL)result message:(NSString *)message;

/**
 *  显示付款视图
 */
- (void)show;

/**
 *  销毁付款视图
 */
- (void)dismiss;

@end
