//
//  GGIautosSessionManager.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGIautosSessionManager.h"
#import "GGReachability.h"

static GGIautosSessionManager *_shareClient = nil;

@implementation GGIautosSessionManager

+ (instancetype)sharedClient{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareClient = [[GGIautosSessionManager alloc]initWithBaseURL:[NSURL URLWithString:BaseIautosUrl]];
    });
    return _shareClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url{
    if (self = [super initWithBaseURL:url]) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
    }
    return self;
}

- (void)getJsonDataWithPath:(NSString *)aPath
                 withParams:(NSDictionary*)params
                   andBlock:(void (^)(id data, NSError *error))block{
    
    if (!aPath || aPath.length <= 0) {
        return;
    }
    
    //监测网络
    if ([[GGReachability shareReachability] currentNetStatus] == NotReachable) {
        NSError *error = [NSError errorWithDomain:@"您的网络异常，请检查是否已开启网络。" code:711 userInfo:nil];
        block(nil,error);
        return;
    }
    
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //参数转换
    params = [self encryptionParametersWithDictionary:params];
    
    [self showNetworkActivityWithStatus:YES];
    
    //所有GET增加缓存机制
    NSMutableString *localPath = [aPath mutableCopy];
    if (params) {
        [localPath appendString:params.description];
    }
    
    [self GET:aPath parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          DLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
          [self showNetworkActivityWithStatus:NO];
          block(responseObject,nil);
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          DLog(@"\n===========response===========\n%@:\n%@", aPath, error);
          [self showNetworkActivityWithStatus:NO];
          block(nil,error);
      }];

    
}


-(void)showNetworkActivityWithStatus:(BOOL)status{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = status;
}

#pragma mark - 取消所有网络请求
- (void)cancelAllRequest{
    [self.operationQueue cancelAllOperations];
}


#pragma mark - 参数再转换
- (NSDictionary *)encryptionParametersWithDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mDic setObject:Iautos_AppKey forKey:@"app_key"];
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

- (NSString *)timeStamp
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString * str = [NSString stringWithFormat:@"%ld", (long) time];
    return str;
}

@end
