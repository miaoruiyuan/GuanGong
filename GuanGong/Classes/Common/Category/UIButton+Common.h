//
//  UIButton+Common.h
//  GuanGong
//
//  Created by 苗芮源 on 16/5/30.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Common)

//线在title底下
- (void)centerImageUnderTitle:(CGFloat )spacing;

- (void)centerImageAndTitle:(float)space;
- (void)centerImageAndTitle;
/**
 *  button的image在title右边
 */
- (void)putImageOnTheRightSideOfTitle;


//开始请求时，UIActivityIndicatorView 提示
- (void)startQueryAnimate;
- (void)stopQueryAnimate;


/**
 *  开始计时器
 */
-(void)startCountDown;
/**
 *  停止计时器
 */
-(void)endTimer;


/**
 This method will show the activity indicator in place of the button text.
 */
- (void)showIndicator;

/**
 This method will remove the indicator and put thebutton text back in place.
 */
- (void)hideIndicator;



@end
