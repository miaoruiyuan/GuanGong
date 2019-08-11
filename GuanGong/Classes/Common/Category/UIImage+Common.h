//
//  UIImage+Common.h
//  GuanGong
//
//  Created by 苗芮源 on 16/5/27.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

/**
 *  图片的压缩方法
 *
 *  @param sourceImg   要被压缩的图片
 *  @param defineWidth 要被压缩的尺寸(宽)
 *
 *  @return 被压缩的图片
 */
+(UIImage *)IMGCompressed:(UIImage *)sourceImg targetWidth:(CGFloat)defineWidth;

/**
 *  调整图片尺寸和大小
 *
 *  @param sourceImage  原图
 *  @param maxImageSize 新图片最大尺寸
 *  @param maxSize      新图片最大存储大小
 *
 *  @return 新图的imageData
 */
+ (NSData *)resizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize;


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

/**
 生成二维码图片
 
 @param string 二维码对应的信息
 @param Imagesize 图片尺寸
 @param waterImagesize 中间的logo
 @return return value description
 */
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize;
@end
