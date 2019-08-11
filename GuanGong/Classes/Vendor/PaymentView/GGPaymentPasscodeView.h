//
//  GGPaymentPasscodeView.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/27.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPasscodeView.h"

@protocol GGPaymentCodeViewDelegate <NSObject>

- (void)didEndEditPasswordWithPaymentPassword:(NSString *)paymentPassword;
- (void)didTappedPasswordViewBackButton;
- (void)didTappedPasswordViewForgetPasswordButton;

@end


@interface GGPaymentPasscodeView : UIView

@property(nonatomic,strong)GGPasscodeView *codeView;
@property (nonatomic, weak) id<GGPaymentCodeViewDelegate> delegate;

@end
