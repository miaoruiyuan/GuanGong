//
//  GGHttpSessionManager.h
//  GuanGong
//
//  Created by 苗芮源 on 16/5/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "GGRSASecurity.h"

typedef enum {
    Get = 0,
    Post,
} NetworkMethod;

typedef NS_ENUM(NSUInteger, UpLoadImageType) {
    UpLoadNormalImage = 11 //上传车辆图片
};

@interface GGHttpSessionManager : AFHTTPSessionManager

+ (instancetype)sharedClient;

@property(nonatomic,strong)GGRSASecurity *rsaSecurity;


- (void)postJsonDataWithPath:(NSString *)aPath
                  withParams:(NSDictionary*)params
                    andBlock:(void (^)(id data, NSError *error))block;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id data, NSError *error))block;




/**
 上传车辆图片

 @param image 图
 @param progress progress description
 @param block block description
 */
//- (void)uploadCarImage:(UIImage *)image
//         progerssBlock:(void (^)(CGFloat progressValue))progress
//              andBlock:(void (^)(id data, NSError *error))block;

/**
 上传图片

 @param image 原图
 @param type
 @param progress 上传进度
 @param block block description
 */
- (void)uploadImage:(UIImage *)image
          imageType:(UpLoadImageType)type
      progerssBlock:(void (^)(CGFloat progressValue))progress
           andBlock:(void (^)(id data, NSError *error))block;


/**
 上传图片,选择大小

 @param image 原图
 @param type type description
 @param maxSize 最大宽边
 @param maxKb 最大
 @param progress progress description
 @param block block description
 */
- (void)uploadImage:(UIImage *)image
          imageType:(UpLoadImageType)type
       imageMaxSize:(CGFloat )maxSize
         imageMaxKb:(CGFloat )maxKb
      progerssBlock:(void (^)(CGFloat progressValue))progress
           andBlock:(void (^)(id data, NSError *error))block;


- (void)downLoadAnImageWithUrlString:(NSString *)urlString
                  withUpLoadProgress:(void(^)(float progress))progress
                            andBlock:(void (^)(id data, NSError *error))block;


- (void)cancelAllRequest;

@end
