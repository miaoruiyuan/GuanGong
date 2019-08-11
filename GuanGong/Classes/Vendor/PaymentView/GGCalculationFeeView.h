//
//  GGCalculationFeeView.h
//  GuanGong
//
//  Created by CodingTom on 2017/3/2.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGcalculationFee.h"

@interface GGCalculationFeeView : UIView

- (void)showWithModel:(GGcalculationFee *)model andNextBlock:(void(^)())nextBlock;

- (void)showRechargeWithModel:(GGcalculationFee *)model andNextBlock:(void(^)())nextBlock;

- (void)dismiss;

@end
