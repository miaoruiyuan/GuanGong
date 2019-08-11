//
//  CWTNetClient.h
//  CheWangTong
//
//  Created by 苗芮源 on 2016/12/10.
//  Copyright © 2016年 ios_miaoruiyuan. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface CWTNetClient : AFHTTPSessionManager

+ (CWTNetClient *)shareClient;

/**
 get请求

 @param path 路劲
 @param params 参数
 @param block block description
 */
- (void)getWithPath:(NSString *)path
         withParams:(NSDictionary*)params
           andBlock:(void (^)(id data, NSError *error))block;


/**
 post请求

 @param path 路径
 @param params 参数
 @param block block description
 */
- (void)postWithPath:(NSString *)path
          withParams:(NSDictionary*)params
            andBlock:(void (^)(id data, NSError *error))block;



/**
 @param path 路劲
 @param params 参数
 @param method 请求方式
 @param block block description
 */

- (void)requestWithPath:(NSString *)path
             withParams:(NSDictionary*)params
         withMethodType:(NetworkMethod)method
               andBlock:(void (^)(id data, NSError *error))block;

- (void)requestWithPath:(NSString *)path
             withParams:(NSDictionary*)params
         withMethodType:(NetworkMethod)method
          autoShowError:(BOOL)autoShowError
               andBlock:(void (^)(id data, NSError *error))block;

- (void)removeCache;

@end
