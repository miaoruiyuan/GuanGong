//
//  GGTransferViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/3.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewController.h"
#import "GGTransferAccountViewModel.h"

@interface GGTransferViewController : GGTableViewController

- (instancetype)initWithItem:(GGAccount *)account;

@property(nonatomic,strong)GGTransferAccountViewModel *transferVM;

@end
