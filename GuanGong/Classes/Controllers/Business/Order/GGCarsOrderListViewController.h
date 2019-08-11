//
//  GGCarsOrderListViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewController.h"
#import "GGCarOrderViewModel.h"

@interface GGCarsOrderListViewController : GGTableViewController

@property(nonatomic,strong)GGCarOrderViewModel *carOrderVM;

@property(nonatomic,assign)BOOL isSeller;

@end
