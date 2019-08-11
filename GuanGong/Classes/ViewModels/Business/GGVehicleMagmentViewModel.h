//
//  GGVehicleMagmentViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGVehicleList.h"
#import "GGCar.h"

@class Parameter;

@interface GGVehicleMagmentViewModel : GGTableViewModel

@property(nonatomic,strong,readonly)RACCommand *carDetailsCommand;
@property(nonatomic,strong,readonly)RACCommand *deleteCommand;


/**
 判断是否是车源列表
 */
@property(nonatomic,assign)BOOL isCarsList;

@property(nonatomic,strong)Parameter *parameter;

@property(nonatomic,strong)NSNotification *notification;

@property(nonatomic,strong)GGCar *car;

@end


@interface Parameter : NSObject

@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,strong)NSNumber *brandId;
@property(nonatomic,strong)NSNumber *seriesId;
@property(nonatomic,strong)NSNumber *provinceId;
@property(nonatomic,strong)NSNumber *cityId;
@property(nonatomic,copy)NSString *priceMin;
@property(nonatomic,copy)NSString *priceMax;

@property(nonatomic,strong)NSNumber *pageNo;
@property(nonatomic,strong)NSNumber *pageSize;

@property(nonatomic,copy)NSString *status;
@property(nonatomic,strong)NSNumber *sort;

@end
