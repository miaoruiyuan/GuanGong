//
//  GGShareCarUtil.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/25.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGShareCarUtil : NSObject

+ (instancetype)sharedInstance;

/**
 *  分享到微信会话
 */
- (void)shareToWeixinSession:(UIImage *)image;

/**
 *  分享到朋友圈
 */
- (void)shareToWeixinTimeline:(UIImage *)image;

@end
