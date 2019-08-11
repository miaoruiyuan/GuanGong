//
//  GGHelpListModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGHelpListModel.h"

@implementation GGHelpListModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"questionId":@"id"};
}

@end
