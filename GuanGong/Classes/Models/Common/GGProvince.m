//
//  GGProvince.m
//  GuanGong
//
//  Created by 苗芮源 on 16/5/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGProvince.h"


@implementation GGProvince


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"proId": @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cityList" : [GGCity class]};
}


@end
