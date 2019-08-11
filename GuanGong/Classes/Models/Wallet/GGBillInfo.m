//
//  GGBillInfo.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBillInfo.h"

@implementation GGBillInfo

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"remark":@"description"};
}

@end
