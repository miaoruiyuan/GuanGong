//
//  GGCarHistoryServiceCompany.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/12.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGCarHistoryServiceCompany.h"

@implementation GGCarHistoryServiceCompany

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"companyID":@"id",
             @"des":@"description"};
}

@end
