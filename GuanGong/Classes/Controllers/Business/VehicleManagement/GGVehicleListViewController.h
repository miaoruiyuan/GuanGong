//
//  GGVehicleListViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/3.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewController.h"

typedef NS_ENUM(NSInteger,VehicleListType) {
    VehicleListTypeSHZ = 2,
    VehicleListTypeWG = 3,
    VehicleListTypeZS = 5,
    VehicleListTypeJYZ = 6,
    VehicleListTypeYS = 7,
    VehicleListTypeTK = 8,
    VehicleListTypeYT = 9,
    VehicleListTypeYQ = 10
};

@interface GGVehicleListViewController : GGTableViewController

@property(nonatomic,assign)VehicleListType listType;

@end
