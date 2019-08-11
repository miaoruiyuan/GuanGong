//
//  GGGoodsInfo.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/9.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGGoodsInfo.h"

@implementation GGGoodsInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"remark":@"description",@"goodsId":@"id"};
}


@end
