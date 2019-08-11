//
//  GGRefundmentViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewController.h"
#import "GGOrderDetails.h"
#import "GGCarOrderDetail.h"

@interface GGRefundmentViewController : GGTableViewController

- (id)initWithObject:(GGOrderDetails *)orderDetail;
- (id)initWithCarOrderObject:(GGCarOrderDetail *)carOrderDetail;

@end
