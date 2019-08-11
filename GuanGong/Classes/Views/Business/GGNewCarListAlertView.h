//
//  GGNewCarListAlertView.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/10.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGNewCarListAlertView : UIView

+ (instancetype)showContent:(NSString *)content andBlock:(void(^)())block;

+ (NSString *)getDefaultContent;

@end
