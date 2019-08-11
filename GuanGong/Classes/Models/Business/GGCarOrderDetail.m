//
//  GGCarOrderDetail.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarOrderDetail.h"

@implementation GGCarOrderDetail

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"carOrderId": @"id",
             @"xinCarGuaranteeDaysCountDown":@"newCarGuaranteeDaysCountDown"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"payOrderRecords":[GGCarOrderRecords class],
             @"backOrderRecords":[GGCarOrderRecords class]};
}

@end

@implementation GGCarOrderRecords

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"recordId": @"id",
             @"remark":@"description"};
}

@end
