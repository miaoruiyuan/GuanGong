//
//  GGAddBankCardRewardAlertView.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/13.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGAddBankCardRewardAlertView : UIView

+ (instancetype)showWithContent:(NSString *)content confirmText:(NSString *)confirmText andBlock:(void(^)(BOOL isCancel))block;

+ (instancetype)showCardWithContent:(NSString *)content onlyShowSubmitBtn:(NSString *)text andBlock:(void(^)(BOOL isCancel))block;

+ (instancetype)showAuthenticateWithContent:(NSString *)content onlyShowSubmitBtn:(NSString *)text andBlock:(void(^)(BOOL isCancel))block;


@end
