//
//  GGOtherPayList.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOtherPayList.h"

@implementation GGOtherPayList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"applyId": @"id"};
}

@end



@implementation GGOtherPayBuyer

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"buyerId": @"id"};
}


@end


@implementation GGOtherPayPayer
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"payerId": @"id"};
}


@end

@implementation GGOtherPaySaler
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"salerId": @"id"};
}


@end