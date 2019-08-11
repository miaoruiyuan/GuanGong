//
//  UIBarButtonItem+Custom.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "UIBarButtonItem+Custom.h"

@implementation UIBarButtonItem (Custom)

+(UIBarButtonItem *)backBarItemWithAction:(void(^)(void))action{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"base_nav_back"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton bk_addEventHandler:^(id sender) {
        if (action) action();
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backItem;
}

+(UIBarButtonItem *)barItemWithTitle:(NSString *)title action:(void (^)(void))action{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setTitleColor:textNormalColor forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleButton sizeToFit];
    [titleButton bk_addEventHandler:^(id sender) {
        if (action) action();
    } forControlEvents:UIControlEventTouchUpInside];
    
    [titleButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:titleButton];
    return leftItem;
}

+(UIBarButtonItem *)barItemWithIco:(NSString *)ico action:(void (^)(void))action{
    UIButton *icoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [icoButton setImage:[UIImage imageNamed:ico] forState:UIControlStateNormal];
    [icoButton sizeToFit];
    [icoButton bk_addEventHandler:^(id sender) {
        if (action) action();
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *icoItem = [[UIBarButtonItem alloc] initWithCustomView:icoButton];
    return icoItem;
}


@end
