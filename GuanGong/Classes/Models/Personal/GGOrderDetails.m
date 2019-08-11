//
//  GGOrderDetails.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/9.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOrderDetails.h"

@implementation GGOrderDetails

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderRecords" : [GGOrderRecords class],
             @"transOrderRecords":[GGOrderRecords class]};
}


@end

@implementation GGOrderRecords

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
     return @{@"remark":@"description",
              @"recordId":@"id"};
}

@end
