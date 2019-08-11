//
//  GGCheckOrderViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckOrderViewController.h"
#import "GGCheckOrderListViewController.h"

@interface GGCheckOrderViewController ()

@end

@implementation GGCheckOrderViewController

- (void)bindViewModel{
}
- (void)setupView{
    self.navigationItem.title = @"质检订单";
    [self setUpAllViewController];
    
//    /*  设置标题渐变：标题填充模式 */
//    [self setUpTitleGradient:^(YZTitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
//        // 标题填充模式
//        *titleColorGradientStyle = YZTitleColorGradientStyleFill;
//        *norColor = textLightColor;
//        *selColor = [UIColor blackColor];
//        
//    }];
    
    
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor,
                             UIColor *__autoreleasing *norColor,
                             UIColor *__autoreleasing *selColor,
                             UIFont *__autoreleasing *titleFont,
                             CGFloat *titleHeight,
                             CGFloat *titleWidth) {
        *norColor = [UIColor colorWithHexString:@"8e8e8e"];
        *selColor = [UIColor colorWithHexString:@"000000"];
        *titleFont = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        *titleWidth = kScreenWidth / 5;
        *titleHeight = 44;
    }];
}

// 添加所有子控制器
- (void)setUpAllViewController{

    NSArray *titles = @[@"全部",@"待确认",@"待支付",@"待检测",@"已完成"];
    
    for (int i = 0 ; i < titles.count; i++) {
        GGCheckOrderListViewController *vc = [[GGCheckOrderListViewController alloc] init];
        vc.title = titles[i];
        if (i == 0) {
            vc.orderStatus = CheckOrderStatusAll;
        }else{
            vc.orderStatus = i - 1;
        }
        
        [self addChildViewController:vc];

    }

}



@end
