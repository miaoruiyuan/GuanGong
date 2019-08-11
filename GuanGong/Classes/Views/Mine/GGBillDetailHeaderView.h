//
//  GGBillDetailHeaderView.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/24.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGBillInfo.h"

@interface GGBillDetailHeaderView : UIImageView

@property(nonatomic,strong)GGBillInfo *info;

@property(nonatomic,strong)RACSignal *btnTapSinal;

@end
