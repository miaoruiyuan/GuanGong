//
//  GGBankCountrywide.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/23.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGBankCity;
@class GGBankCountry;

@interface GGBankProvince : NSObject

@property(nonatomic,copy)NSString *nodeName;
@property(nonatomic,strong)NSNumber *nodeCode;
@property(nonatomic,strong)NSArray *citys;

@end


@interface GGBankCity : NSObject

@property(nonatomic,copy)NSString *areaName;
@property(nonatomic,strong)NSNumber *topAreaCode2;
@property(nonatomic,strong)NSArray *areas;

@end



@interface GGBankCountry : NSObject

@property(nonatomic,copy)NSString *areaName;
@property(nonatomic,strong)NSNumber *oraAreaCode;

@end
