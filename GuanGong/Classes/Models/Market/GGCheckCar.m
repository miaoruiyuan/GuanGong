//
//  GGCheckCar.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckCar.h"

@implementation GGCheckCar


+ (nullable NSArray<NSString *> *)modelPropertyBlacklist{
    return @[@"city"];
}

- (NSString *)checkServiceKey{
    return @"autobole";
}



@end
