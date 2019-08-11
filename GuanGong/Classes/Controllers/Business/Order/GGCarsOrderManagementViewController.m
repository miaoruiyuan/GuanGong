//
//  GGCarsOrderManagementViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarsOrderManagementViewController.h"
#import "GGCarsOrderListViewController.h"

@interface GGCarsOrderManagementViewController ()

@property(nonatomic,assign)BOOL isSeller;

@end

@implementation GGCarsOrderManagementViewController

- (instancetype)initSellerController:(BOOL)isSeller
{
    if (self = [super init]) {
        _isSeller = isSeller;
    }
    return self;
}

- (void)setupView{
    self.navigationItem.title = _isSeller ? @"卖车订单" : @"买车订单";
    [self setUpAllViewController];
//    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor,
//                             UIColor *__autoreleasing *norColor,
//                             UIColor *__autoreleasing *selColor,
//                             UIFont *__autoreleasing *titleFont,
//                             CGFloat *titleHeight,
//                             CGFloat *titleWidth) {
//        *norColor = [UIColor colorWithHexString:@"8e8e8e"];
//        *selColor = [UIColor colorWithHexString:@"000000"];
//        *titleFont = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
//        *titleWidth = kScreenWidth / 4;
//        *titleHeight = 44;
//    }];
//
//
//    // 去除 tabbar 50 height
//    [self setUpContentViewFrame:^(UIView *contentView) {
//        contentView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 50);
//    }];
}

// 添加所有子控制器
- (void)setUpAllViewController{
//    NSArray *titles = @[@"全部",@"待付款",@"待收货",@"已完成",@"退款中"];
    NSArray *titles = @[@"全部",@"待付款",@"待收货",@"已完成"];
    for (int i = 0 ; i < titles.count; i++) {
        GGCarsOrderListViewController *vc = [[GGCarsOrderListViewController alloc] init];
        vc.isSeller = self.isSeller;
        vc.title = titles[i];
        [self addChildViewController:vc];
        vc.carOrderVM.orderListType = i;
        vc.carOrderVM.isSeller = self.isSeller;
    }
}

@end
