//
//  GGProgressView.h
//  PayPassword
//
//  Created by 苗芮源 on 16/8/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AnimationStopBlock)(BOOL isFinish);
@interface GGPayAnimationView : UIView

/**
 *  动画完成回调block
 */
@property(nonatomic,copy)AnimationStopBlock stopBlock;

- (void)showProgressView:(NSString *)infoStr stopAnimation:(AnimationStopBlock)stopBlock;

- (void)showSuccess:(NSString *)infoStr;
@end
