//
//  GGCarsListCell.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGVehicleList.h"

UIKIT_EXTERN NSString *const kCellIdentifierCarsList;
@interface GGCarsListCell : UITableViewCell

@property(nonatomic,strong)GGVehicleList *car;

@end