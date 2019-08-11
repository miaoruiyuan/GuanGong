//
//  GGImage.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGImageItem.h"
#import "PHAsset+Asset.h"

@implementation GGImageItem

+ (instancetype)imageWithPHAsset:(PHAsset *)asset{
    GGImageItem *item = [[GGImageItem alloc] init];
    item.uploadState = GGImageUploadStateInit;
    item.photoIdentifier = asset.localIdentifier;

//    [asset fetchImage:GGFetchImageTypeOrigin
//          synchronous:NO
//          resultBlock:^(UIImage *image) {
//              NSData *data = [UIImage resizeImageData:image maxImageSize:1080 maxSizeWithKB:300];
//              item.image = [UIImage imageWithData:data];
//          }];
    
    [asset fetchImageData:^(NSData *data) {
        NSData *imgData = [UIImage resizeImageData:[UIImage imageWithData:data] maxImageSize:2000 maxSizeWithKB:300];
        item.imageData = imgData;
    }];
    
    [asset fetchThumbnailImage:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            item.thumbnailImage = image;
        });
    }];
    
    [asset fetchImage:GGFetchImageTypeFullScreen synchronous:NO resultBlock:^(UIImage *image) {
        item.fullScreenImage = image;
    }];

    return item;
}

+ (instancetype)imageWithImage:(UIImage *)image
{
    GGImageItem *item = [[GGImageItem alloc] init];
    item.uploadState = GGImageUploadStateInit;
    item.photoIdentifier = nil;
    item.fullScreenImage = image;
    item.thumbnailImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(256, 256)];
    NSData *imgData = [UIImage resizeImageData:image maxImageSize:2000 maxSizeWithKB:300];
    item.imageData = imgData;
    return item;
}

+ (instancetype)imageWithPHAsset:(PHAsset *)asset andImage:(UIImage *)image{
    GGImageItem *item = [[GGImageItem alloc] init];
    item.uploadState = GGImageUploadStateInit;
    item.photoIdentifier = asset.localIdentifier;
    item.thumbnailImage = [image imageByResizeToSize:CGSizeMake(80, 80) contentMode:UIViewContentModeScaleAspectFill];
    return item;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self modelEncodeWithCoder:aCoder];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self modelInitWithCoder:aDecoder];
}

@end
