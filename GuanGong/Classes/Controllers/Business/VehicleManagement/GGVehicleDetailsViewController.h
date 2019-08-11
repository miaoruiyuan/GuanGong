//
//  GGVehicleDetailsViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewController.h"
#import "GGVehicleList.h"

@interface GGVehicleDetailsViewController : GGTableViewController

- (id)initWithItem:(GGVehicleList *)car;

@property(nonatomic,assign)BOOL isMyVehicle;

@end
