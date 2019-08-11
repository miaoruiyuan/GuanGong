//
//  GGPhotoBroswerTransitionAnimator.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGPhotoBroswerTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>
/**
 *  动画时间
 */
@property(nonatomic, assign)CGFloat duration;

/**
 *  展示或消失
 */
@property(nonatomic, assign)BOOL presenting;


@end
