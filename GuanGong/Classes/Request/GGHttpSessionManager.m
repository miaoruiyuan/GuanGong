//
//  GGHttpSessionManager.m
//  GuanGong
//
//  Created by 苗芮源 on 16/5/26.
//  Copyright © 2016年 iautos. All rights reserved.
//
#import "GGHttpSessionManager.h"
#import "GGReachability.h"
#import "APIUrl.h"

#define kNetworkMethodName @[@"Get", @"Post"]

@interface GGHttpSessionManager ()

@end

static GGHttpSessionManager *_shareClient = nil;

@implementation GGHttpSessionManager

- (GGRSASecurity *)rsaSecurity{
    if (!_rsaSecurity) {
        _rsaSecurity = [[GGRSASecurity alloc]init];
    }
    return _rsaSecurity;
}

+ (instancetype)sharedClient{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareClient = [[GGHttpSessionManager alloc]initWithBaseURL:[NSURL URLWithString:BaseUrl]];
    });
    return _shareClient;
}


- (instancetype)initWithBaseURL:(NSURL *)url{
    if (self = [super initWithBaseURL:url]) {
        
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];

        
//        NSString *cerPath = [[NSBundle mainBundle] pathForResource:HttpsDomain ofType:@"cer"];
//        NSData *certData =[NSData dataWithContentsOfFile:cerPath];
//        NSSet *certSet = [[NSSet alloc] initWithObjects:certData, nil];
//        
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        
//        //是否允许无效证书
//        securityPolicy.allowInvalidCertificates = YES;
//        [securityPolicy setValidatesDomainName:NO];
//        [securityPolicy setPinnedCertificates:certSet];

#warning Change By Tom AFSecurityPolicy

        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolicy setAllowInvalidCertificates:YES];
        [securityPolicy setValidatesDomainName:NO];
        
        self.securityPolicy = securityPolicy;
        
        NSString *privatePath = [[NSBundle mainBundle] pathForResource:Sign_FileName ofType:@"p12"];
        NSString *publichPath = [[NSBundle mainBundle] pathForResource:Encrypt_FileName ofType:@"der"];
        [self.rsaSecurity loadPrivateKeyFromFile:privatePath password:Sign_Password];
        [self.rsaSecurity loadPublicKeyFromFile:publichPath];
    }
    return self;
}

- (void)postJsonDataWithPath:(NSString *)aPath
                  withParams:(NSDictionary*)params
                    andBlock:(void (^)(id data, NSError *error))block{
    
    [self requestJsonDataWithPath:aPath
                       withParams:params
                   withMethodType:Post
                         andBlock:block];
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary *)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block{
    
    [self requestJsonDataWithPath:aPath
                       withParams:params
                   withMethodType:method
                    autoShowError:YES
                         andBlock:block];
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary *)params
                 withMethodType:(NetworkMethod)method
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id data, NSError *error))block{
    
    
    if (!aPath || aPath.length <= 0) {
        return;
    }
    
    //监测网络
    if ([[GGReachability shareReachability] currentNetStatus] == NotReachable) {
        NSError *error = [NSError errorWithDomain:@"您的网络异常，请检查是否已开启网络。" code:711 userInfo:nil];
        [NSObject showStatusBarErrorStr:@"您的网络异常，请检查是否已开启网络"];
        block(nil,error);
        return;
    }
    
    
    //log请求数据
//    DLog(@"\n===========request===========\n%@\n%@:\n%@", kNetworkMethodName[method], aPath, params);
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //参数转换
    params = [self encryptionParametersWithDictionary:params];
    
    [self showNetworkActivityWithStatus:YES];
    switch (method) {
        case Get:{
            //所有GET增加缓存机制
            NSMutableString *localPath = [aPath mutableCopy];
            if (params) {
                [localPath appendString:params.description];
            }
            
            [self GET:aPath
           parameters:params
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  block(responseObject,nil);
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  block(nil,error);
              }];
            
        }
            
            break;
            
        case Post:{
            
            [self POST:aPath
            parameters:params
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   [self showNetworkActivityWithStatus:NO];
                   [MBProgressHUD hideHUD];
                   id error = [self handleResponse:responseObject];
                   if (error) {
                       DLog(@"\n\n===========POST Request Error===========\n%@:\n%@\n--------Response Error--------\n%@",
                            task.currentRequest.URL.absoluteString,
                            [params modelDescription],
                            error);
                       [MBProgressHUD hideHUD];
                       block(nil,error);
                   }else{
                       if ([responseObject isKindOfClass:[NSDictionary class]]) {
                           id result = [responseObject valueForKeyPath:@"data"];
                           if ([result isEqual:[NSNull null]]) {
                               block(nil,error);
                               return ;
                           }
                           DLog(@"\n\n===========POST Request===========\n%@:\n%@\n--------Response Data--------\n%@",
                                task.currentRequest.URL.absoluteString,
                                [params modelDescription],
                                [responseObject modelDescription]);
                           block(result,nil);
                       }
                   }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self showNetworkActivityWithStatus:NO];
                [MBProgressHUD hideHUD];
                DLog(@"\n\n===========POST Request Error===========\n%@:\n%@\n--------Response Error--------\n%@",
                     task.currentRequest.URL.absoluteString,
                     [params modelDescription],
                     error);
                !autoShowError || [NSObject showError:error];
                block(nil,error);
            }];
        }
        default:
            break;
    }
}

//- (void)uploadCarImage:(UIImage *)image
//         progerssBlock:(void (^)(CGFloat progressValue))progress
//              andBlock:(void (^)(id data, NSError *error))block{
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyyMMddHHmmss";
//    NSString *str = [formatter stringFromDate:[NSDate date]];
//    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//    
//    
//    NSString *path = @"file/add";
//    [self POST:path parameters:[self encryptionParametersWithDictionary:@{@"cid":@1,@"Filename":fileName}] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSData *data = UIImageJPEGRepresentation(image, 1.0);
//        [formData appendPartWithFileData:data name:@"Filedata" fileName:@"" mimeType:@"image/jpeg"];
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        progress(uploadProgress.fractionCompleted);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [MBProgressHUD hideHUD];
//        id error = [self handleResponse:responseObject];
//        if (error) {
//            DLog(@"\n===========response===========\n%@:\n%@", path, error);
//            block(nil,error);
//        }else{
//            if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                id result = [responseObject valueForKeyPath:@"data"];
//                if ([result isEqual:[NSNull null]]) {
//                    block(nil,error);
//                    return ;
//                }
//                DLog(@"\n===========response===========\n%@:\n%@", path, responseObject);
//                block(result,nil);
//            }
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD hideHUD];
////        block(nil, error);
//        DLog(@"\n===========response===========\n%@:\n%@", path, error);
//        [NSObject showError:error];
//        block(nil,error);
//    }];
//
//    
//}

- (void)uploadImage:(UIImage *)image
          imageType:(UpLoadImageType)type
      progerssBlock:(void (^)(CGFloat progressValue))progress
           andBlock:(void (^)(id data, NSError *error))block{
    
    [self uploadImage:image
            imageType:type
         imageMaxSize:1080
           imageMaxKb:500
        progerssBlock:progress
             andBlock:block];
}

- (void)uploadImage:(UIImage *)image
          imageType:(UpLoadImageType)type
       imageMaxSize:(CGFloat )maxSize
         imageMaxKb:(CGFloat )maxKb
      progerssBlock:(void (^)(CGFloat progressValue))progress
           andBlock:(void (^)(id data, NSError *error))block{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    NSString *path = @"file/add";
    [self POST:path parameters:[self encryptionParametersWithDictionary:@{@"cid":@(type),@"Filename":fileName}] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imgData = [UIImage resizeImageData:image maxImageSize:maxSize maxSizeWithKB:maxKb];
        
        [formData appendPartWithFileData:imgData name:@"Filedata" fileName:@"" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        id error = [self handleResponse:responseObject];
        if (error) {
            DLog(@"\n===========response===========\n%@:\n%@", path, error);
            block(nil,error);
        }else{
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                id result = [responseObject valueForKeyPath:@"data"];
                if ([result isEqual:[NSNull null]]) {
                    block(nil,error);
                    return ;
                }
                DLog(@"\n===========response===========\n%@:\n%@", path, responseObject);
                block(result,nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
//        block(nil, error);
        DLog(@"\n===========response===========\n%@:\n%@", path, error);
        [NSObject showError:error];
        block(nil,error);
    }];
}

- (void)downLoadAnImageWithUrlString:(NSString *)urlString
                 withUpLoadProgress:(void(^)(float progress))progress
                           andBlock:(void (^)(id data, NSError *error))block{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [[self downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            block(nil,error);
        }else{
           block(filePath,nil);
        }
    
    }] resume];
}


-(void)showNetworkActivityWithStatus:(BOOL)status{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = status;
}


#pragma mark - 取消所有网络请求
- (void)cancelAllRequest
{
    [self.operationQueue cancelAllOperations];
}

#pragma mark - 参数再转换
- (NSDictionary *)encryptionParametersWithDictionary:(NSDictionary *)dic{
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [mDic setObject:[self timeStamp] forKey:@"requestTime"];
    [mDic setObject:@"IOS" forKey:@"requestSource"];
    [mDic setObject:GGAppKey forKey:@"appKey"];
    [mDic setObject:[[UIApplication sharedApplication] appVersion] forKey:@"appVersion"];

    if ([GGLogin shareUser].token.length > 0) {
        [mDic setObject:[GGLogin shareUser].token forKey:@"token"];
    }
    
    NSArray *keys = [mDic allKeys];
    
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2){
        return [obj1 compare:obj2];
    }];
    
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:keys.count];
    for (int i = 0; i<keys.count; i++) {
        NSString *key = keys[i];
        NSString *value = [NSString stringWithFormat:@"%@=%@",key,mDic[key]];
        [valueArray addObject:value];
    }
    
    NSString *valueSring = [valueArray componentsJoinedByString:@"&"];

//    DLog(@"参数拼接结果:%@",valueSring);
    
    //签名:进行签名
    NSString *signature = [[self.rsaSecurity sha256WithRSA:[valueSring dataUsingEncoding:NSUTF8StringEncoding]] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [mDic setObject:signature forKey:@"signature"];
    
    
//    //验证签名是否成功
//    BOOL isSuccess = [self.rsaSecurity rsaSHA256VertifyingData:valueSring withSignature:signature];
//    NSLog(@"签名是否成功:%d",isSuccess);
//
//    
//    
//    NSString *jiamiData = [self.rsaSecurity rsaEncryptString:@"123456"];
//    
//    NSLog(@"加密结果:%@",jiamiData);
//    
//
//    NSString *jiemiData = [self.rsaSecurity rsaDecryptString:jiamiData];
//    
//    NSLog(@"解密结果:%@",jiemiData);
//    
    

    return mDic;
}



- (NSString *)timeStamp{
    NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    NSString * str = [NSString stringWithFormat:@"%ld", (long) time];
    return str;
}

@end
