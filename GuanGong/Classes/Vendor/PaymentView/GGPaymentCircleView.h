//
//  GGPaymentCircleView.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/27.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,GGLoadStatus) {
    GGLoadStatusLoading,
    GGLoadStatusSuccess,
    GGLoadStatusFailed
};

@interface GGPaymentCircleView : UIView

/**
 *  加载状态
 *
 *  @param status 状态
 */
- (void)loadStatus:(GGLoadStatus )status;

/**
 *  清楚图层
 */
- (void)cleanLayer;

@end
