//
//  GGFriendApplyPageViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFriendApplyPageViewController.h"
#import "GGFriendApplyViewController.h"

@interface GGFriendApplyPageViewController ()

@end

@implementation GGFriendApplyPageViewController


- (void)setupView
{
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
    
    [self setUpContentViewFrame:^(UIView *contentView) {
        contentView.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight-64);
    }];

}

// 添加所有子控制器
- (void)setUpAllViewController{

    GGFriendApplyViewController *vc1 = [[GGFriendApplyViewController alloc] init];
    vc1.title = @"全部";
    vc1.otherPayVM.status = OtherPayStatusNone;
    [self addChildViewController:vc1];
    
    GGFriendApplyViewController *vc2 = [[GGFriendApplyViewController alloc] init];
    vc2.title = @"待处理";
    vc2.otherPayVM.status = OtherPayStatusDCL;
    [self addChildViewController:vc2];


    GGFriendApplyViewController *vc3 = [[GGFriendApplyViewController alloc] init];
    vc3.title = @"已代付";
    vc3.otherPayVM.status = OtherPayStatusYDF;
    [self addChildViewController:vc3];
    
    
    GGFriendApplyViewController *vc4 = [[GGFriendApplyViewController alloc] init];
    vc4.title = @"已拒绝";
    vc4.otherPayVM.status = OtherPayStatusYJJ;
    [self addChildViewController:vc4];
    
    
    GGFriendApplyViewController *vc5 = [[GGFriendApplyViewController alloc] init];
    vc5.title = @"已取消";
    vc5.otherPayVM.status = OtherPayStatusYQX;
    [self addChildViewController:vc5];
}

@end
