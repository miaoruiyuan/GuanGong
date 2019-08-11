//
//  GGCarHistoryRechargeOrderModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/14.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGCarHistoryRechargeOrderModel.h"

@implementation GGCarHistoryRechargeOrderModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"service" : [GGCarHistoryServiceCompany class],
             @"price" : [GGSearvicePriceListModel class]
             };
}

@end
