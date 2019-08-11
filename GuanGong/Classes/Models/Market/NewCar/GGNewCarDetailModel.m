//
//  GGNewCarDetailModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/9.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGNewCarDetailModel.h"

@implementation GGNewCarDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"carId": @"id"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"wareStockResponse":[GGNewCarWareStockModel class],
             @"user":[GGUser class],};
}

@end
