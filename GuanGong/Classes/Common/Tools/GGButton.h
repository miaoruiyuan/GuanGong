//
//  GGButton.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/20.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSUInteger,GGButtonStyle) {
    //普通
    GGButtonStyleNormal,
    //实心
    GGButtonStyleSolid,
    //空心标签
    GGButtonStyleHollowTag,
    //空心
    GGButtonStyleHollow,
    //纯文字（金色）
    GGButtonStyleText,
    //上下布局
    GGButtonStyleUpDown,
};


@interface GGButton : UIButton

- (instancetype)initWithButtonTitle:(NSString *)title style:(GGButtonStyle)style size:(CGFloat)size;

- (instancetype)initWithButtonTitle:(NSString *)title style:(GGButtonStyle)style size:(CGFloat)size ico:(NSString *)ico highlighIco:(NSString *)highlighIco;

- (instancetype)initWithButtonTitle:(NSString *)title style:(GGButtonStyle)style size:(CGFloat)size highlighImage:(UIColor *)highlighColor;

- (void)upateTitle:(NSString *)title;


@end
