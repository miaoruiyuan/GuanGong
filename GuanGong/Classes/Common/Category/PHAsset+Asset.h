//
//  PHAsset+Asset.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Photos/Photos.h>

typedef NS_ENUM(NSUInteger, GGFetchImageType) {
    GGFetchImageTypeThumbnail = 0,
    GGFetchImageTypeFullScreen,
    GGFetchImageTypeOrigin
};

typedef void (^GGAssetFetchImageResultsBlock)(UIImage *image);
typedef void (^GGAssetFetchImageDataResultsBlock)(NSData *data);

@interface PHAsset (Asset)

- (void) fetchThumbnailImage:(GGAssetFetchImageResultsBlock)fetchBlock;
- (void) fetchImage:(GGFetchImageType)type synchronous:(BOOL)sync resultBlock:(GGAssetFetchImageResultsBlock)fetchBlock;
//获取要求大小的图片，同步方法
- (void) fetchImageWithSize:(CGSize)targetSize resultBlock:(GGAssetFetchImageResultsBlock)fetchBlock;
- (void) fetchImageData:(GGAssetFetchImageDataResultsBlock)fetchBlock;


@end
