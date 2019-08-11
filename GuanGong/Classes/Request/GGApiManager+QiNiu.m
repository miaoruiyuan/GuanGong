//
//  GGApiManager+QiNiu.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGApiManager+QiNiu.h"

@implementation GGApiManager(QiNiu)

#pragma mark - 获取7牛上传的token

+(RACSignal *)getUploadToken{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"file/qiniu/getToken"
                                                       withParams:nil
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

+(RACSignal *)getPrivateUploadToken{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"file/qiniu/getPrivateToken"
                                                       withParams:nil
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

+(RACSignal *)getPrivateUploadURL:(NSString *)baseURL{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"file/qiniu/getPrivateUrl"
                                                       withParams:@{@"baseUrl":baseURL}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

#pragma mark - 7牛上传
+ (void)uploadWithImage:(NSData *)imageData
                  token:(NSString *)token
                    key:(NSString *)key
               progress:(QNUpProgressHandler)progress
               andBlock:(void (^)(id data, NSError *error))block{
    
    QNFileRecorder *recorder = [QNFileRecorder fileRecorderWithFolder:[NSTemporaryDirectory() stringByAppendingString:@"qiniu"] error:nil];
    QNUploadManager *uploadManager = [[QNUploadManager alloc] initWithRecorder:recorder];
    
    QNUploadOption *option = [[QNUploadOption alloc] initWithMime:nil
                                                  progressHandler:progress
                                                           params:nil
                                                         checkCrc:NO
                                               cancellationSignal:^BOOL{
                                                   return NO;
                                               }];
    
    [uploadManager putData:imageData key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if ([info error]) {
            block(nil,[info error]);
        }else{
            block(resp,nil);
        }
    }option:option];
    
}


@end
