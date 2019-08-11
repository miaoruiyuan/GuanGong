//
//  GGVinInfoServicePriceViewModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGCarHistoryServiceCompany.h"
#import "GGCarHistoryRechargeOrderModel.h"


@interface GGVinInfoServicePriceViewModel : GGTableViewModel

@property(nonatomic,strong,readonly)RACCommand *servicePriceListCommand;

@property(nonatomic,strong,readonly)RACCommand *createRechargeCommand;

@property(nonatomic,strong)GGCarHistoryRechargeOrderModel *orderModel;

@end
