//
//  GGCarBrand.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarBrand.h"

@implementation GGCarBrand

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"brandId": @"id"};
}

@end

@implementation GGCarSeries

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"car_series" : [GGSeries class]};
}


@end

@implementation GGCarMfrs

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"mfrsId": @"id"};
}

@end

@implementation GGSeries

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"seriesId": @"id"};
}

@end


@implementation GGCarModel

@end



@implementation GGModelList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelId": @"id",@"n_price":@"new_price"};
}

@end
