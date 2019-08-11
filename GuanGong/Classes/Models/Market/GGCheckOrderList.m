//
//  GGCheckOrderList.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckOrderList.h"

@implementation GGCheckOrderList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"orderId": @"id",@"remark":@"description"};
}


@end
