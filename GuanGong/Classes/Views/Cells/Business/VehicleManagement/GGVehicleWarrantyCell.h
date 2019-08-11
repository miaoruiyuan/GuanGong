//
//  GGVehicleWarrantyCell.h
//  GuanGong
//
//  Created by CodingTom on 2017/2/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kGGVehicleWarrantyCellID;


@interface GGVehicleWarrantyCell : UITableViewCell

@property (nonatomic,strong) UIButton *submitBtn;

- (void)updateUIWithStatus:(BOOL)checked;

@end
