//
//  CWTNetClient.m
//  CheWangTong
//
//  Created by 苗芮源 on 2016/12/10.
//  Copyright © 2016年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTNetClient.h"
#import "GGReachability.h"
#import "GGApiManager+QiNiu.h"

#define kCWTNetworkMethodName @[@"Get", @"Post"]
@implementation CWTNetClient
+ (CWTNetClient *)shareClient{
    static dispatch_once_t onceToken;
    static CWTNetClient *netClient;
    dispatch_once(&onceToken, ^{
        netClient = [[CWTNetClient alloc] initWithBaseURL:[NSURL URLWithString:BaseIautosUrl]];
    });
    return netClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url{
    if (self = [super initWithBaseURL:url]) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
//        [self.requestSerializer setValue:[JGBLogin login].sessionId forHTTPHeaderField:@"jsessionid"];
    }
    
    return self;
}

#pragma mark - Get请求
- (void)getWithPath:(NSString *)path withParams:(NSDictionary *)params andBlock:(void (^)(id, NSError *))block{
    [self requestWithPath:path withParams:params withMethodType:Get andBlock:block];
}
#pragma mark - Post请求
- (void)postWithPath:(NSString *)path withParams:(NSDictionary *)params andBlock:(void (^)(id, NSError *))block{
    [self requestWithPath:path withParams:params withMethodType:Post andBlock:block];
}

- (void)requestWithPath:(NSString *)path
             withParams:(NSDictionary *)params
         withMethodType:(NetworkMethod)method
               andBlock:(void (^)(id, NSError *))block{
    [self requestWithPath:path withParams:params withMethodType:method autoShowError:YES andBlock:block];
}


- (void)requestWithPath:(NSString *)path
             withParams:(NSDictionary*)params
         withMethodType:(NetworkMethod)method
          autoShowError:(BOOL)autoShowError
               andBlock:(void (^)(id data, NSError *error))block{

    //监测网络
    if ([[GGReachability shareReachability] currentNetStatus] == NotReachable) {
        NSError *error = [NSError errorWithDomain:@"您的网络异常，请检查是否已开启网络。" code:711 userInfo:nil];
        block(nil,error);
        return;
    }
    
    if (!path || path.length <= 0) {
        return;
    }
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //log请求数据
    DLog(@"\n===========request===========\n%@\n%@:\n%@", kCWTNetworkMethodName[method], path, params);
    
    //显示网络请求的菊花
    [self showNetworkActivityWithStatus:YES];
    switch (method) {
        case Get:{
            //所有GET增加缓存机制
            NSMutableString *localPath = [path mutableCopy];
            if (params) {
                [localPath appendString:params.description];
            }
            
            [self GET:path
           parameters:[self encryptionParametersWithDictionary:params]
             progress:^(NSProgress * _Nonnull downloadProgress) {
                 
             }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  [self showNetworkActivityWithStatus:NO];
                  
                  if ([responseObject isKindOfClass:[NSDictionary class]]) {
                      NSError *error = [self handleResponseObject:responseObject];
                      if (error) {
                          block(nil,error);
                      }else{
                          if (responseObject[@"data"]) {
                              block(responseObject[@"data"],nil);
                          }else{
                              block(responseObject,nil);
                          }
                      }
                  }else{
                       block(responseObject,nil);
                  }
                  
                   DLog(@"\n===========response===========\n%@:\n%@", path, responseObject);
                  
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  [self showNetworkActivityWithStatus:NO];
                  DLog(@"\n===========response===========\n%@:\n%@", path, error);
                  if (autoShowError) {
                      [NSObject showError:error];
                  }
                  block(nil,error);
              }];

        }
            break;
            
            
        case Post:{
            [self POST:path
            parameters:[self encryptionParametersWithDictionary:params]
              progress:^(NSProgress * _Nonnull uploadProgress) {
                  
              }
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   [self showNetworkActivityWithStatus:NO];
                   if ([responseObject isKindOfClass:[NSDictionary class]]) {
                       NSError *error = [self handleResponseObject:responseObject];
                       if (error) {
                           block(nil,error);
                       }else{
                           if (responseObject[@"data"]) {
                               block(responseObject[@"data"],nil);
                           }else{
                               block(responseObject,nil);
                           }
                       }
                   }else{
                       block(responseObject,nil);
                   }
                   
                   DLog(@"\n===========response===========\n%@:\n%@", path, responseObject);
               }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   [self showNetworkActivityWithStatus:NO];
                
                   DLog(@"\n===========response===========\n%@:\n%@", path, error);
                   !autoShowError || [NSObject showError:error];
                   block(nil,error);
               }];
            
        }
       
            break;
        default:
            break;
    }

}


#pragma mark - 上传图片
+ (void)uploadImageWithImageData:(NSData *)data
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
    [uploadManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if ([info error]) {
            block(nil,[info error]);
        }else{
            block(resp,nil);
        }
    }option:option];

    
    
}


#pragma mark - 参数再转换
- (NSDictionary *)encryptionParametersWithDictionary:(NSDictionary *)dic{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mDic setObject:Iautos_AppKey forKey:@"app_key"];
    [mDic setObject:[[UIApplication sharedApplication] appVersion] forKey:@"app_version"];
  
    NSString *timestamp = [self timeStamp];
    [mDic setObject:timestamp forKey:@"timestamp"];
    
    NSArray *keys = [mDic allKeys];
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2){
        return [obj1 compare:obj2];
    }];
    
    NSString *signResult = @"";
    for (int i = 0; i<keys.count; i++) {
        NSString *key = keys[i];
        NSString *value = [NSString stringWithFormat:@"%@%@",key,[mDic objectForKey:key]];
        signResult = [NSString stringWithFormat:@"%@%@",signResult,value];
    }
    
    NSString *secret = Iautos_AppSecret;
    NSString *sign = [[NSString stringWithFormat:@"%@%@%@",secret,signResult,secret]md5String];
    [mDic setObject:sign forKey:@"sign"];
    
    
    return mDic;
}

- (NSString *)timeStamp{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString * str = [NSString stringWithFormat:@"%ld", (long) time];
    return str;
}





-(void)showNetworkActivityWithStatus:(BOOL)status{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = status;
}




#pragma mark NetError
- (id)handleResponseObject:(id)responseObject{
    return [self handleResponseObject:responseObject showError:YES];
}
- (id)handleResponseObject:(id)responseObject showError:(BOOL)show{
    NSError *error = nil;
    //responseCode为非200值时，表示有错
    NSDictionary *resultData = [responseObject valueForKey:@"data"];
    
    if (resultData) {
        NSInteger resultCode = [[responseObject valueForKey:@"status"] integerValue];
        if (resultCode != 1) {
            error = [NSError errorWithDomain:BaseIautosUrl code:resultCode userInfo:responseObject];
            if (responseObject[@"error_code"]) {
                NSInteger errorCode = [responseObject[@"error_code"] integerValue];
                if (errorCode == 21301 || errorCode == 20266) {
                    return error;
                }
                [UIAlertView bk_showAlertViewWithTitle:nil message:responseObject[@"error"] cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
            }else{
                NSString *errorStr = [NSString errorDescription:resultCode];
                [UIAlertView bk_showAlertViewWithTitle:nil message:errorStr cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
            }
        }
    }

    
    return error;
}


- (void)removeCache{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}





@end
