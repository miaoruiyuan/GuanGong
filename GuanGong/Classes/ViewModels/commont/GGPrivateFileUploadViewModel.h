//
//  GGPrivateFileUploadViewModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/15.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGViewModel.h"
#import "GGQiNiu.h"

@interface GGPrivateFileUploadViewModel : GGViewModel

+ (instancetype)sharedClient;

- (void)refreshPrivateToken;

- (void)uploadQNPrivateImage:(UIImage *)image
       imageMaxSize:(CGFloat )maxSize
         imageMaxKb:(CGFloat )maxKb
      progerssBlock:(void (^)(CGFloat progressValue))progress
           andBlock:(void (^)(id data, NSError *error))block;


- (NSString *)getImageURLByKey:(NSString *)qiNiuKey;

@end
