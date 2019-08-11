//
//  UIBarButtonItem+Custom.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Custom)

+(UIBarButtonItem *)backBarItemWithAction:(void(^)(void))action;
+(UIBarButtonItem *)barItemWithTitle:(NSString *)title action:(void (^)(void))action;
+(UIBarButtonItem *)barItemWithIco:(NSString *)ico action:(void (^)(void))action;


@end
