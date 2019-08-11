//
//  GGBillList.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/15.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBillList.h"

@implementation GGBillList

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"result":[BillItem class]};
}

@end



@implementation BillItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"remark": @"description"};
}

@end
