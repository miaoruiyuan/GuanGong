//
//  GGAddressPageRoute.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGAddressPageRoute.h"
#import "GGInputViewController.h"
#import "GGLocationViewController.h"

@implementation GGAddressPageRoute

+ (void)pushWithItem:(GGFormItem *)item nav:(UINavigationController *)nav callBack:(void(^)(id x))callBack{
    
    GGBaseViewController *viewController = nil;

    if (!item.canEdit) {
        return;
    }
    
    //输入框
    if (item.pageType == GGPageTypeInput) {
        viewController = [[GGInputViewController alloc] initWithItem:item];
    }
    
    //所在地
    if (item.pageType == GGPageTypeCityList) {
        viewController = [[GGLocationViewController alloc] initWithItem:item];
    }
    
    viewController.popHandler = callBack;
    [nav pushViewController:viewController animated:YES];

}

@end
