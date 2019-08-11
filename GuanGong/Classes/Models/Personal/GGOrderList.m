//
//  GGOrderList.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOrderList.h"

@implementation GGOrderList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"orderId": @"id",@"order_description":@"description"};
}

@end
