//
//  GGTrade.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTrade.h"

@implementation GGTrade

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist{
    
    return @[@"dynamicCode",@"password"];
}


@end
