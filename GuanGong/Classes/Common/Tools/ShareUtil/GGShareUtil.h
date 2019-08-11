//
//  GGShareUtil.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/15.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGShareUtil : NSObject

/**
 *  分享标题
 */
@property (nonatomic, strong) NSString *shareTitle;

/**
 *  分享内容
 */
@property (nonatomic, strong) NSString *shareText;

/**
 *  分享链接地址
 */
@property (nonatomic, strong) NSString *shareUrl;

@end
