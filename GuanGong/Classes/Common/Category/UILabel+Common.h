//
//  UILabel+Common.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/30.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Common)

#pragma mark - Label内容左右对齐

- (void)changeAlignmentRightAndLeft;

/**
 Set this property to YES in order to enable the copy feature. Defaults to NO.
 */
@property (nonatomic) IBInspectable BOOL copyingEnabled;

/**
 Used to enable/disable the internal long press gesture recognizer. Defaults to YES.
 */
@property (nonatomic) IBInspectable BOOL shouldUseLongPressGestureRecognizer;

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
