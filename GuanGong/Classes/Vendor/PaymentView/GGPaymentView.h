//
//  GGPaymentView.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/27.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGPaymentViewDelegate <NSObject>

- (void)didTappedConfirmButtonWithPaymentMethod:(GGPaymentMethod )method paymentPassword:(NSString *)paymentPassword;
- (void)didTappedColseButton;
- (void)didTappedForgetPasswordButton;
- (void)paymentComplete;

@end


@interface GGPaymentView : UIView

@property (nonatomic, weak) id<GGPaymentViewDelegate> delegate;


/**
 *  快速创建一个付款视图
 *
 *  @param info          付款详情
 *  @param money         金额
 *  @param paymentMethod 付款方式
 */
- (instancetype)initWithInfo:(NSString *)info money:(NSString *)money paymentMethod:(GGPaymentMethod)paymentMethod;
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
