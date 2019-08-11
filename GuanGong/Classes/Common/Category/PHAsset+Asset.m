//
//  PHAsset+Asset.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "PHAsset+Asset.h"

static NSInteger kThumbnailSizeWith = 80;
@implementation PHAsset (Asset)

#pragma mark - 获取缩略图
- (void)fetchThumbnailImage:(GGAssetFetchImageResultsBlock)fetchBlock{
    
    NSInteger retinaScale = [UIScreen mainScreen].scale;
    CGSize retinaSquare = CGSizeMake(kThumbnailSizeWith*retinaScale, kThumbnailSizeWith*retinaScale);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.synchronous = NO;
    CGFloat cropSideLength = MIN(self.pixelWidth, self.pixelHeight);
    CGRect square = CGRectMake(0, 0, cropSideLength, cropSideLength);
    CGRect cropRect = CGRectApplyAffineTransform(square,
                                                 CGAffineTransformMakeScale(1.0 / self.pixelWidth,
                                                                            1.0 / self.pixelHeight));
    options.normalizedCropRect = cropRect;
    
    [[PHImageManager  defaultManager] requestImageForAsset:self targetSize:retinaSquare contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        fetchBlock(result);
    }];
    
}
#pragma mark - 获取图片
- (void)fetchImage:(GGFetchImageType)type synchronous:(BOOL)sync resultBlock:(GGAssetFetchImageResultsBlock)fetchBlock{
    
    switch (type) {
        case GGFetchImageTypeThumbnail:
            [self fetchThumbnailImage:fetchBlock];
            break;
            
        case GGFetchImageTypeFullScreen:{
            
            CGSize size = [UIScreen mainScreen].bounds.size;
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize targetSize = CGSizeMake(size.width * scale, size.height *scale);
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.resizeMode = PHImageRequestOptionsResizeModeExact;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
            options.synchronous = sync;
            
            [[PHImageManager  defaultManager] requestImageForAsset:self targetSize:targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                fetchBlock(result);
            }];
            
        }
            break;
            
        case GGFetchImageTypeOrigin:{
            
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.resizeMode = PHImageRequestOptionsResizeModeExact;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            options.synchronous = sync;
            
            [[PHImageManager  defaultManager] requestImageForAsset:self targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                fetchBlock(result);
            }];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 获取指定尺寸图片,同步方法
- (void)fetchImageWithSize:(CGSize)targetSize resultBlock:(GGAssetFetchImageResultsBlock)fetchBlock{
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = YES;
    
    [[PHImageManager  defaultManager] requestImageForAsset:self targetSize:targetSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        fetchBlock(result);
    }];
    
}
#pragma mark - 获取图片二进制文件
- (void)fetchImageData:(GGAssetFetchImageDataResultsBlock)fetchBlock{
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.synchronous = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:self options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        fetchBlock(imageData);
    }];
    
}



@end
