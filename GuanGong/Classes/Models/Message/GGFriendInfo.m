//
//  GGFriendInfo.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFriendInfo.h"

@implementation GGFriendInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"company" : [GGCompanyModel class]
             };
}

@end
