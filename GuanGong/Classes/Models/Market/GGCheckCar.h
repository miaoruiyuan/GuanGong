//
//  GGCheckCar.h
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGCheckCar : NSObject

@property(nonatomic,copy)NSString *vin;
@property(nonatomic,strong)NSNumber *brandId;
@property(nonatomic,strong)NSNumber *seriesId;
@property(nonatomic,strong)NSNumber *modelId;
@property(nonatomic,copy)NSString *carProvince;
@property(nonatomic,copy)NSString *carCity;
@property(nonatomic,copy)NSString *saleName;
@property(nonatomic,copy)NSString *saleTel;
@property(nonatomic,copy)NSString *checkServiceKey;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *city;

@end
