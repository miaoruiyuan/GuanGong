//
//  GGVehicleInfoCell.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCar.h"
#import "GGNewCarDetailModel.h"

UIKIT_EXTERN NSString *const kCellIdentifierVehicleInfo;

@interface GGVehicleInfoCell : UITableViewCell

@property(nonatomic,strong)GGCar *car;

- (void)updateUIWithModel:(GGNewCarDetailModel *)detailModel;

@end
