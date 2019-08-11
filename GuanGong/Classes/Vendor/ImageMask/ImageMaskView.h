//
//  ImageMaskView.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/9.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageMaskView;
@protocol ImageMaskFilledDelegate
- (void)imageMaskView:(ImageMaskView *)maskView clearPercentDidChanged:(float)clearPercent;
@end

@interface ImageMaskView : UIImageView{
    size_t tilesX;
    size_t tilesY;
}


@property (nonatomic, readonly) double procentsOfImageMasked;
@property (nonatomic, assign) id<ImageMaskFilledDelegate> imageMaskFilledDelegate;
@property (nonatomic, assign) CGFloat radius;

- (void)beginInteraction;


@end
