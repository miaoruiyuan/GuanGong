//
//  GGTabBarViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/4/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTabBarViewController.h"
#import "GGMarketViewController.h"
#import "GGBusinessViewController.h"
#import "GGMessageViewController.h"
#import "GGPersonalViewController.h"
#import "GGNavigationController.h"
#import "GGSetPayPasswordViewController.h"
#import "GGCreateCarViewController.h"

#import "GGCarsOrderManagementViewController.h"

@interface GGTabBarViewController ()
@end

@implementation GGTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTabBarItems]; //在设置ViewControllers之前设置
    [self setViewControllers];
}

- (void)setViewControllers{
    GGMarketViewController *marketVC = [[GGMarketViewController alloc]init];
    GGNavigationController *marketNav = [[GGNavigationController alloc]initWithRootViewController:marketVC];
//    
    GGCarsOrderManagementViewController *businessVC = [[GGCarsOrderManagementViewController alloc] initSellerController:NO];

//    GGBusinessViewController *businessVC = [[GGBusinessViewController alloc] init];
    GGNavigationController *businessNav = [[GGNavigationController alloc]initWithRootViewController:businessVC];

    GGMessageViewController *messageVC = [[GGMessageViewController alloc]init];
    GGNavigationController *messageNav = [[GGNavigationController alloc]initWithRootViewController:messageVC];

    
    GGPersonalViewController *personalVC = [[GGPersonalViewController alloc]init];
    GGNavigationController *personalNav = [[GGNavigationController alloc]initWithRootViewController:personalVC];
    self.viewControllers = @[marketNav,businessNav,messageNav,personalNav];
}

- (void)setTabBarItems{
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"首页",
                            CYLTabBarItemImage : @"tabbar_market_normal",
                            CYLTabBarItemSelectedImage : @"tabbar_market_selected",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"订单",
//                            CYLTabBarItemTitle : @"生意",
                            CYLTabBarItemImage : @"tabbar_order_normal",
                            CYLTabBarItemSelectedImage : @"tabbar_order_selected",
                            };
    
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"兄弟",
                            CYLTabBarItemImage : @"tabbar_friend_normal",
                            CYLTabBarItemSelectedImage : @"tabbar_friend_selected",
                            };
  
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"我的",
                            CYLTabBarItemImage : @"tabbar_mine_normal",
                            CYLTabBarItemSelectedImage : @"tabbar_mine_selected"
                            };

    self.tabBarItemsAttributes = @[dict1,dict2,dict3,dict4];
    
    [self setUpTabBarItemTextAttributes];
    
    //检测是否设置过支付密码
    [self.checkPayPassword execute:nil];
}


- (void)setUpTabBarItemTextAttributes {
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"929292"];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = themeColor;
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];

    
    UITabBar *tabBarAppearance = [UITabBar appearance];
    [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background_os7"]];
}

- (RACCommand *)checkPayPassword
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[GGApiManager request_hasSetPayPassword] map:^id(NSNumber *value) {
            [[NSUserDefaults standardUserDefaults]setObject:@(value.boolValue) forKey:GGPaymentPassword];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return [RACSignal empty];
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
