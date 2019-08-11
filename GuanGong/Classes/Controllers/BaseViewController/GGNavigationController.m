//
//  GGNavigationController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/4/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGNavigationController.h"

@interface GGNavigationController ()

@end

@implementation GGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}


//第一次使用这个类的时候调用1次
+ (void)initialize{
    [self setupNavigationBarTheme];
}


//设置UINavigationBarTheme主题
+ (void)setupNavigationBarTheme {
    
    UINavigationBar *appearance = [UINavigationBar appearance];
    appearance.tintColor = [UIColor colorWithHexString:@"#181818"];
    
//    appearance.backIndicatorImage = [UIImage imageNamed:@"base_nav_back"];
//    appearance.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"base_nav_back"];
//    appearance.titleTextAttributes = @{NSFontAttributeName :[UIFont systemFontOfSize:18 weight:UIFontWeightRegular],NSShadowAttributeName :[[NSShadow alloc] init]};
    
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"base_nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    appearance.backIndicatorImage = backButtonImage;
    appearance.backIndicatorTransitionMaskImage = backButtonImage;


}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 判断是否为栈底控制器
    if (self.viewControllers.count > 0 ) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
}




@end
