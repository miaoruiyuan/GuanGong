//
//  GGNewCarOrderViewModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/10.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGViewModel.h"
#import "GGNewCarDetailModel.h"
#import "GGCarOrderDetail.h"

@interface GGNewCarOrderViewModel : GGViewModel

@property(nonatomic,strong)GGNewCarDetailModel *carDetailModel;

@property(nonatomic,strong)RACCommand *carOrderCommand;

@property(nonatomic,strong)GGCarOrderDetail *carOrderDetail;

@end
