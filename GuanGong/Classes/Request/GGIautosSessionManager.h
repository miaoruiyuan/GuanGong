//
//  GGIautosSessionManager.h
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface GGIautosSessionManager : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (void)getJsonDataWithPath:(NSString *)aPath
                 withParams:(NSDictionary*)params
                   andBlock:(void (^)(id data, NSError *error))block;

@end
