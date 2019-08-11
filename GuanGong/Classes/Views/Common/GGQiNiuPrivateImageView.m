//
//  GGQiNiuPrivateImageView.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/18.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGQiNiuPrivateImageView.h"
#import "GGApiManager+QiNiu.h"

@interface GGQiNiuPrivateImageView()

@end

@implementation GGQiNiuPrivateImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)gg_setImageeURL:(NSString *)imageURL placeholder:(UIImage *)placeholder
{
    if (placeholder) {
        self.image = placeholder;
    }
    if (!imageURL) {
        return;
    }else if ([[self.imageURL absoluteString] containsString:imageURL]) {
        [self qiniu_yy_setImageWithURL:self.imageURL placeholder:placeholder];
    }else{
        [self getQiNiuShowURL:imageURL andBlock:^(id data, NSError *error) {
            if (data) {
                [self qiniu_yy_setImageWithURL:[NSURL URLWithString:data] placeholder:placeholder];
            }
        }];
    }
}

- (void)qiniu_yy_setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder
{
    [self setImageWithURL:imageURL
                 placeholder:placeholder
                     options:YYWebImageOptionAllowInvalidSSLCertificates|YYWebImageOptionIgnoreDiskCache
                    progress:nil
                   transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                       return [image imageByResizeToSize:CGSizeMake(kScreenWidth - 40, (kScreenWidth -40) *.75) contentMode:UIViewContentModeScaleAspectFill];
                   }
                  completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                  }];
}


- (void)getQiNiuShowURL:(NSString *)url andBlock:(void (^)(id data, NSError *error))block
{
    [[GGApiManager getPrivateUploadURL:url] subscribeNext:^(id data) {
        block(data,nil);
        
    } error:^(NSError *error) {
        block(nil,error);
    }];
}

@end
