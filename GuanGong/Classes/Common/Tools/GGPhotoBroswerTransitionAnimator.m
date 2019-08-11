//
//  GGPhotoBroswerTransitionAnimator.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPhotoBroswerTransitionAnimator.h"

@implementation GGPhotoBroswerTransitionAnimator

- (instancetype)init{
    if (self = [super init]) {
        self.duration = .25;
        self.presenting = YES;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (self.presenting) {
        // 1. Get controllers from transition context
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        // 2. Set init frame for toVC
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.frame = CGRectOffset(finalFrame, 0, screenBounds.size.height);
        
        // 3. Add toVC's view to containerView
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toVC.view];
        
        // 4. Do animate now
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        
        [UIView animateWithDuration:duration delay:.0 options:UIViewAnimationOptionCurveLinear animations:^{
            toVC.view.frame = finalFrame;
        } completion:^(BOOL finished) {
            // 5. Tell context that we completed.
            [transitionContext completeTransition:YES];
        }];
        
        
    }else{
        
        // 1. Get controllers from transition context
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        // 2. Set init frame for fromVC
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
        CGRect finalFrame = CGRectOffset(initFrame, 0, screenBounds.size.height);
        
        // 3. Add target view to the container, and move it to back.
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toVC.view];
        [containerView sendSubviewToBack:toVC.view];
        
        // 4. Do animate now
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration animations:^{
            fromVC.view.frame = finalFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }
}




@end
