//
//  GGBankCountrywide.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/23.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBankProvince.h"

@implementation GGBankProvince

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    
    return @{@"citys":[GGBankCity class]};
}


@end


@implementation GGBankCity

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    
    return @{@"areas":[GGBankCountry class]};
}

@end



@implementation GGBankCountry

@end