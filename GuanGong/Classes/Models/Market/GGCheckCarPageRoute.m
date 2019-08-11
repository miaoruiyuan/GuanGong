//
//  GGCheckCarPageRoute.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckCarPageRoute.h"
#import "GGLocationViewController.h"
#import "GGInputViewController.h"
#import "GGCheckCarSeriesViewController.h"

@implementation GGCheckCarPageRoute

+ (void)pushWithItem:(GGFormItem *)item nav:(UINavigationController *)nav callBack:(void(^)(id x))callBack{
    GGBaseViewController *viewController = nil;
    
    if (!item.canEdit) {
        return;
    }
    
    //输入框
    if (item.pageType == GGPageTypeInput) {
        viewController = [[GGInputViewController alloc]initWithItem:item];
    }
    //所在地
    if (item.pageType == GGPageTypeCheckCarCity) {
        viewController = [[GGLocationViewController alloc] initWithItem:item];
    }
    //车型
    if (item.pageType == GGPageTypeCarModel) {
        viewController = [[GGCheckCarSeriesViewController alloc] initWithItem:item];
    }

    

    viewController.popHandler = callBack;
    [nav pushViewController:viewController animated:YES];
}

@end
