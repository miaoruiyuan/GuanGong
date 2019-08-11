//
//  GGPaymentOrderRootViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/31.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGPaymentOrderPageViewController.h"
#import "GGBuyerListViewController.h"
#import "GGSellerListViewController.h"

@interface GGPaymentOrderPageViewController ()

@property (nonatomic,assign)BOOL isBuyerOrder;

@end

@implementation GGPaymentOrderPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initBuyerOrderViewController
{
    self = [super init];
    if (self) {
        _isBuyerOrder = YES;
    }
    return self;
}

- (instancetype)initSellerOrderViewController
{
    self = [super init];
    if (self) {
        _isBuyerOrder = NO;
    }
    return self;
}

- (void)setupView
{
    if (self.isBuyerOrder) {
        [self setupBuyerAllViewController];
    }else{
        [self setupSellerAllViewController];
    }
    
//    /*  设置标题渐变：标题填充模式 */
//    [self setUpTitleGradient:^(YZTitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
//        // 标题填充模式
//        *titleColorGradientStyle = YZTitleColorGradientStyleFill;
//        *norColor = textLightColor;
//        *selColor = [UIColor blackColor];
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
        *titleWidth = kScreenWidth / 3;
        *titleHeight = 44;
    }];
    
    [self setUpContentViewFrame:^(UIView *contentView) {
        contentView.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight - 64);
    }];
}

- (void)setupBuyerAllViewController{
    
    GGBuyerListViewController *vc1 = [[GGBuyerListViewController alloc] initBuyerListWithStatus:@"1"];
    vc1.title = @"交易中";
    [self addChildViewController:vc1];
    
    GGBuyerListViewController *vc2 = [[GGBuyerListViewController alloc] initBuyerListWithStatus:@"2"];
    vc2.title = @"退款中";
    [self addChildViewController:vc2];
    
    
    GGBuyerListViewController *vc3 = [[GGBuyerListViewController alloc] initBuyerListWithStatus:@"3"];
    vc3.title = @"已完成";
    [self addChildViewController:vc3];
}

- (void)setupSellerAllViewController{
    
    GGSellerListViewController *vc1 = [[GGSellerListViewController alloc] initSellerListWithStatus:@"1"];
    vc1.title = @"交易中";
    [self addChildViewController:vc1];
    
    GGSellerListViewController *vc2 = [[GGSellerListViewController alloc] initSellerListWithStatus:@"2"];
    vc2.title = @"退款中";
    [self addChildViewController:vc2];
    
    
    GGSellerListViewController *vc3 = [[GGSellerListViewController alloc] initSellerListWithStatus:@"3"];
    vc3.title = @"已完成";
    [self addChildViewController:vc3];
}

@end
