//
//  GGVehicleOwnerCell.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/14.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kCellIdentifierVehicleOwner;

@interface GGVehicleOwnerCell : UITableViewCell

@property(nonatomic,strong)GGUser *info;

@end