//
//  GGImage.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GGImageUploadState){
    GGImageUploadStateInit = 0,
    GGImageUploadStateIng,
    GGImageUploadStateSuccess,
    GGImageUploadStateFail
};


@interface GGImageItem : NSObject<NSCoding>

@property (readwrite, nonatomic, strong) UIImage *thumbnailImage,*fullScreenImage;
@property(nonatomic,strong)NSData *imageData;
@property (nonatomic, copy)NSString *photoIdentifier;
@property(nonatomic,copy)NSString *photoUrl;
@property(nonatomic,copy)NSString *thumbnailPhotoUrl;
@property (assign, nonatomic) GGImageUploadState uploadState;

+ (instancetype)imageWithPHAsset:(PHAsset *)asset;
+ (instancetype)imageWithPHAsset:(PHAsset *)asset andImage:(UIImage *)image;
+ (instancetype)imageWithImage:(UIImage *)image;

@end
