//
//  GGVehicleWarrantyItemCell.h
//  GuanGong
//
//  Created by CodingTom on 2017/2/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGFormItem.h"

UIKIT_EXTERN NSString *const kGGVehicleWarrantyItemCell;

@interface GGVehicleWarrantyItemCell : UITableViewCell

- (void)updateUIWithModel:(GGFormItem *)model;

@end
