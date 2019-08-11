//
//  GGShareWechatUtil.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/15.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGShareUtil.h"

@interface GGShareWechatUtil : GGShareUtil

/**
 *  分享到微信会话
 */
- (void)shareToWeixinSession;

/**
 *  分享到朋友圈
 */
- (void)shareToWeixinTimeline;

+ (instancetype)sharedInstance;

@end
