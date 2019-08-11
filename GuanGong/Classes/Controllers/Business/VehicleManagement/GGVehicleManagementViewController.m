//
//  GGVehicleManagementViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/3.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGVehicleManagementViewController.h"
#import "GGVehicleListViewController.h"

@interface GGVehicleManagementViewController ()

@end

@implementation GGVehicleManagementViewController

- (void)setupView{
    self.navigationItem.title = @"车辆管理";
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
        *titleWidth = kScreenWidth / 4;
        *titleHeight = 44;
    }];
}

// 添加所有子控制器
- (void)setUpAllViewController{
    NSArray *titles = @[@"在售",@"交易中",@"已售",@"未上架"];
    for (int i = 0 ; i < titles.count; i++) {
        GGVehicleListViewController *vc = [[GGVehicleListViewController alloc] init];
        vc.title = titles[i];
        [self addChildViewController:vc];
        
        switch (i) {
            case 0:
                vc.listType = VehicleListTypeZS;
                break;
                
            case 1:
                vc.listType = VehicleListTypeJYZ;
                break;
                
            case 2:
                vc.listType = VehicleListTypeYS;
                break;
                
            default:
                vc.listType = VehicleListTypeWG;
                break;
        }
        
    }

}

@end
