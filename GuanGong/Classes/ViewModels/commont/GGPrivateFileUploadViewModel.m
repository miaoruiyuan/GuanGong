//
//  GGPrivateFileUploadViewModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/15.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGPrivateFileUploadViewModel.h"
#import "GGApiManager+QiNiu.h"

@interface GGPrivateFileUploadViewModel()
{

}

@property (nonatomic,strong)GGQiNiu *qiNiu;

@end

static GGPrivateFileUploadViewModel *_shareClient = nil;

@implementation GGPrivateFileUploadViewModel

+ (instancetype)sharedClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareClient = [[GGPrivateFileUploadViewModel alloc]init];
    });
    return _shareClient;
}

- (NSString *)getImageURLByKey:(NSString *)qiNiuKey
{
    NSString *baseURL = [NSString stringWithFormat:@"%@%@",self.qiNiu.domain,qiNiuKey];
    return baseURL;
}

- (NSString *)getPrivateFileKey
{
    return [NSString stringWithFormat:@"%@%ld%.6d.jpg",self.qiNiu.namePre,[[NSDate date] second],arc4random_uniform(999999)];
}

- (void)refreshPrivateToken
{
    [self getQiNiuPrivateTokenWithBlock:^(id data, NSError *error) {
        DLog(@"refreshPrivateToken");
    }];
}

- (void)uploadQNPrivateImage:(UIImage *)image
                imageMaxSize:(CGFloat )maxSize
                  imageMaxKb:(CGFloat )maxKb
               progerssBlock:(void (^)(CGFloat progressValue))progress
                    andBlock:(void (^)(id data, NSError *error))block
{
    [self getQiNiuPrivateTokenWithBlock:^(id data, NSError *error) {
        if (error) {
            block(nil,error);
        } else {
            NSData *imgData = [UIImage resizeImageData:image maxImageSize:maxSize maxSizeWithKB:maxKb];
            [self uploadImageWithData:imgData progerssBlock:progress andBlock:block];
        }
    }];
}

- (void)uploadImageWithData:(NSData *)imageData progerssBlock:(void (^)(CGFloat progressValue))progress
                   andBlock:(void (^)(id data, NSError *error))block
{
    [GGApiManager uploadWithImage:imageData token:self.qiNiu.uptoken key:[self getPrivateFileKey] progress:^(NSString *key, float percent) {
        if (progress) {
            progress((CGFloat)percent);
        }
    } andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil,error);
        } else {
            NSString *qiNiuKey = data[@"key"];
            NSString *imageURL = [self getImageURLByKey:qiNiuKey];
            block(imageURL,nil);
        }
    }];
}

- (void)getQiNiuPrivateTokenWithBlock:(void (^)(id data, NSError *error))block
{
    if (self.qiNiu.uptoken) {
        if (block) {
            block(self.qiNiu,nil);
        }
        return;
    }
    [[GGApiManager getPrivateUploadToken] subscribeNext:^(NSDictionary *value) {
        self.qiNiu = [GGQiNiu modelWithDictionary:value];
        block(self.qiNiu,nil);
    } error:^(NSError *error) {
        block(nil,error);
    }];
}

//- (void)getQiNiuShowURL:(NSString *)url andBlock:(void (^)(id data, NSError *error))block
//{
//    [[GGApiManager getPrivateUploadURL:url] subscribeNext:^(id data) {
//        block(data,nil);
//    } error:^(NSError *error) {
//        block(nil,error);
//    }];
//}


@end
