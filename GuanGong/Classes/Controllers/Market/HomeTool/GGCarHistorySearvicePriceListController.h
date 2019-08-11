//
//  GGCarHistorySearvicePriceListController.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/12.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGTableViewController.h"
#import "CWTSearchVinViewModel.h"
#import "GGVinInfoViewModel.h"

@interface GGCarHistorySearvicePriceListController : GGTableViewController

- (instancetype)initWithSearchVinVM:(CWTSearchVinViewModel *)searchVinVM;

- (instancetype)initWithVinInfoVM:(GGVinInfoViewModel *)vinInfoVM;

@end
