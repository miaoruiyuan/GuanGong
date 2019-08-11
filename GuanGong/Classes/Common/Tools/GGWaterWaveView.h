//
//  GGWaterWaveView.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/12.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GGWaterWaveAnimateType) {
    GGWaterWaveAnimateTypeShow,
    GGWaterWaveAnimateTypeHide,
};

@interface GGWaterWaveView : UIView

@property(nonatomic, strong)UIColor *firstWaveColor;    // 第一个波浪颜色
@property(nonatomic, strong)UIColor *secondWaveColor;   // 第二个波浪颜色
@property(nonatomic, strong)UIColor *thirdWaveColor;   // 第3个波浪颜色
@property(nonatomic, assign)CGFloat percent;            // 上升高度最大百分比

- (void)startWave;
- (void)stopWave;
- (void)reset;
- (void)removeFromParentView;

@end
