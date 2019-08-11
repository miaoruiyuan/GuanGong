//
//  GGUserActivityModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/18.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGUserActivityModel.h"

@implementation GGUserActivityModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"des":@"description"};
}

@end
