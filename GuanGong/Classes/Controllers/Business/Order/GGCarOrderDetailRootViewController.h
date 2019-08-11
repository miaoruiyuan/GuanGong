//
//  GGCarOrderDetailRootViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/12/9.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBaseViewController.h"
#import "GGCarOrderDetail.h"

@interface GGCarOrderDetailRootViewController : GGBaseViewController

@property(nonatomic,strong)GGCarOrderDetail *orderDetail;

@property(nonatomic,assign)BOOL isSeller;

- (void)reloadOrderData;

@end
