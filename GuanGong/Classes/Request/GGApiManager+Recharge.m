//
//  GGApiManager+Vin.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGApiManager+Recharge.h"

@implementation GGApiManager(Recharge)


+ (RACSignal *)request_GetChargeRateWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"khks/getChargeRate"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}
/**
 获取已开通银行卡列表
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_GetOpenCardListWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"khks/getOpenedCards"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}


/**
 查询支付订单
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_GetPayOrderWithParameter:(NSDictionary *)parameter{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"khks/getPayOrder"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

/**
 银行卡开通充值申请
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_OpenBankCardApplyWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"khks/openCardApply"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

/**
 发送充值支付验证码
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_SendBankPaySMSWithParameter:(NSDictionary *)parameter{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"khks/paySMS"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

/**
 充值支付确认
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_BankPayConfirmWithParameter:(NSDictionary *)parameter{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"khks/payConfirm"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

@end
