//
//  GGShareHeader.m
//  GuanGong-Store
//
//  Created by miaoruiyuan on 2019/8/9.
//  Copyright © 2019 iautos. All rights reserved.
//

#import "GGShareHeader.h"
#import "GGTabBarViewController.h"

@implementation GGShareHeader

+ (void)openGuanGongWithController:(UIViewController *)controller{
    GGTabBarViewController *tabVc = [[GGTabBarViewController alloc] init];
    [controller presentViewController:controller animated:YES completion:^{}];
}
@end
