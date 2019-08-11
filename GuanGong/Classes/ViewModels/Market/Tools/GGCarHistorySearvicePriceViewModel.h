//
//  GGCarHistorySearvicePriceViewModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/12.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGCarHistoryServiceCompany.h"
#import "GGCarHistoryRechargeOrderModel.h"

@interface GGCarHistorySearvicePriceViewModel : GGTableViewModel

@property(nonatomic,strong)GGCarHistoryServiceCompany *serviceCompany;
@property(nonatomic,strong)GGCarHistoryRechargeOrderModel *orderModel;

@property(nonatomic,strong,readonly)RACCommand *createRechargeCommand;
@property(nonatomic,strong,readonly)RACCommand *servicePriceListCommand;

@end
