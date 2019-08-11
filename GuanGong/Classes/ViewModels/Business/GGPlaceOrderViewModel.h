//
//  GGPlaceOrderViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGViewModel.h"
#import "GGCar.h"
#import "GGNewCarDetailModel.h"
#import "GGCarOrderDetail.h"

@interface GGPlaceOrderViewModel : GGViewModel

@property(nonatomic,strong)GGCar *car;

@property(nonatomic,strong)RACCommand *placeOrderCommand;

@property(nonatomic,strong)GGCarOrderDetail *carOrderDetail;

@end
