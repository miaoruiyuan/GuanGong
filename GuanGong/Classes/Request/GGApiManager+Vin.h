//
//  GGApiManager+Vin.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGApiManager.h"

@interface GGApiManager(Vin)

#pragma mark - VIN 维修保养记录 查询

/**
 车史服务商列表
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_CarHistoryServiceListWithParameter:(NSDictionary *)parameter;

/**
 车史服务商套餐价格列表
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_CarHistoryServicePriceListWithParameter:(NSDictionary *)parameter;


/**
 购买车史服务
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_BuyCarHistoryServiceWithParameter:(NSDictionary *)parameter;

/**
 车史服务商套餐下订单
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_CarHistoryServiceCreateRechargeWithParameter:(NSDictionary *)parameter;

/**
 车史服务商剩余次数
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_CarHistoryBalanceWithParameter:(NSDictionary *)parameter;


/**
 车史查询历史列表
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_CarHistoryListWithParameter:(NSDictionary *)parameter;

/**
 车史查询历史详情
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_CarHistoryDetailWithParameter:(NSDictionary *)parameter;

#pragma mark - 用户活动
/**
 获取用户活动信息
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_UserActivityWithParameter:(NSDictionary *)parameter;

/**
 活动操作
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_ExecuteActivityWithParameter:(NSDictionary *)parameter;


#pragma mark - VIN Info

/**
 VIN查询服务商列表
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_VINServiceListWithParameter:(NSDictionary *)parameter;

/**
VIN查询服务商套餐价格列表
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_VINServicePriceListWithParameter:(NSDictionary *)parameter;


/**
 VIN获得不同车型
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_GetVINDiffModelsWithParameter:(NSDictionary *)parameter;

/**
 购买VIN查询服务
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_BuyVINServiceWithParameter:(NSDictionary *)parameter;

/**
 VIN查询服务商套餐下订单
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_VINServiceCreateRechargeWithParameter:(NSDictionary *)parameter;

/**
 VIN查询服务商剩余次数
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_VINBalanceWithParameter:(NSDictionary *)parameter;


/**
 VIN查询历史列表
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_VINListWithParameter:(NSDictionary *)parameter;

/**
 VIN查询历史详情
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_VINDetailWithParameter:(NSDictionary *)parameter;


@end
