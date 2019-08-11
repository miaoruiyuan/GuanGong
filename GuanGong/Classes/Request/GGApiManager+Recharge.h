//
//  GGApiManager+Vin.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGApiManager.h"

@interface GGApiManager(Recharge)


/**
 获取充值手续费
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_GetChargeRateWithParameter:(NSDictionary *)parameter;

/**
 获取已开通银行卡列表
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_GetOpenCardListWithParameter:(NSDictionary *)parameter;


/**
 查询支付订单
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_GetPayOrderWithParameter:(NSDictionary *)parameter;

/**
 银行卡开通充值申请
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_OpenBankCardApplyWithParameter:(NSDictionary *)parameter;

/**
 发送充值支付验证码
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_SendBankPaySMSWithParameter:(NSDictionary *)parameter;

/**
 充值支付确认
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_BankPayConfirmWithParameter:(NSDictionary *)parameter;


@end
