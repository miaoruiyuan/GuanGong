//
//  GGTransferDetailViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 16/8/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewController.h"
#import "GGTransferAccountViewModel.h"

@interface GGTransferDetailViewController : GGTableViewController

- (instancetype)initWithObject:(GGTransferAccountViewModel *)accountVM;

@end
