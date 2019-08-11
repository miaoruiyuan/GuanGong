//
//  GGProvince.h
//  GuanGong
//
//  Created by 苗芮源 on 16/5/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGCity.h"

@interface GGProvince : NSObject

@property(nonatomic,strong)NSMutableArray *cityList;
@property(nonatomic,copy)NSString *areaName;
@property(nonatomic,copy)NSString *areaEName;
@property(nonatomic,strong)NSNumber *proId;

@end
