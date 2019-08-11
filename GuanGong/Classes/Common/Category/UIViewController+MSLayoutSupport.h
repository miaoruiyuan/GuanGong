//
//  UIViewController+MSLayoutSupport.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/18.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MSLayoutSupport)

- (id<UILayoutSupport>)ms_navigationBarTopLayoutGuide;
- (id<UILayoutSupport>)ms_navigationBarBottomLayoutGuide;
@end
