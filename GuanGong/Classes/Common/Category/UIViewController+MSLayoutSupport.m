//
//  UIViewController+MSLayoutSupport.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/18.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "UIViewController+MSLayoutSupport.h"

@implementation UIViewController (MSLayoutSupport)


- (id<UILayoutSupport>)ms_navigationBarTopLayoutGuide {
    if (self.parentViewController && ![self.parentViewController isKindOfClass:UINavigationController.class]) {
        return self.parentViewController.ms_navigationBarTopLayoutGuide;
    } else {
        return self.topLayoutGuide;
    }
}

- (id<UILayoutSupport>)ms_navigationBarBottomLayoutGuide {
    if (self.parentViewController && ![self.parentViewController isKindOfClass:UINavigationController.class]) {
        return self.parentViewController.ms_navigationBarBottomLayoutGuide;
    } else {
        return self.bottomLayoutGuide;
    }
}


@end
