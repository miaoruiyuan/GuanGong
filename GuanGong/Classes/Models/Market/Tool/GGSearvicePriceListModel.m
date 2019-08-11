//
//  GGSearvicePriceListModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/13.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGSearvicePriceListModel.h"

@implementation GGSearvicePriceListModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"priceId":@"id",
             @"des":@"description"};
}

@end
