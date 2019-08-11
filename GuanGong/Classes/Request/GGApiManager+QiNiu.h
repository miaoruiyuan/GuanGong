//
//  GGApiManager+QiNiu.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGApiManager.h"
#import <Qiniu/QiniuSDK.h>

@interface GGApiManager(QiNiu)

#pragma mark -  七牛上传图片
/**
 获取上传token
 
 @return return value description
 */
+(RACSignal *)getUploadToken;

+(RACSignal *)getPrivateUploadToken;

+(RACSignal *)getPrivateUploadURL:(NSString *)baseURL;

/**
 *  七牛上传
 *
 *  @param data     二进制
 *  @param token    token
 *  @param key      key
 *  @param progress progress description
 *  @param block    block description
 */
+ (void)uploadWithImage:(NSData *)imageData
                  token:(NSString *)token
                    key:(NSString *)key
               progress:(QNUpProgressHandler)progress
               andBlock:(void (^)(id data, NSError *error))block;

@end
