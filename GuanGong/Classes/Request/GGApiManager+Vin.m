//
//  GGApiManager+Vin.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGApiManager+Vin.h"

@implementation GGApiManager(Vin)

#pragma mark -  车史服务商列表

+ (RACSignal *)request_CarHistoryServiceListWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"carhistory/serviceList"
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

#pragma mark -  购买车史服务

+ (RACSignal *)request_BuyCarHistoryServiceWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"carhistory/buyReport"
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

#pragma mark -  车史服务商套餐价格列表

+ (RACSignal *)request_CarHistoryServicePriceListWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"carhistory/servicePriceList"
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

#pragma mark -  车史服务套餐下订单

+ (RACSignal *)request_CarHistoryServiceCreateRechargeWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"carhistory/createRecharge"
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

#pragma mark -  车史服务商剩余次数

+ (RACSignal *)request_CarHistoryBalanceWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"carhistory/balance"
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


#pragma mark -  车史查询列表

+ (RACSignal *)request_CarHistoryListWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"carhistory/reportList"
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

#pragma mark -  车史查询历史详情
+ (RACSignal *)request_CarHistoryDetailWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"carhistory/reportDetail"
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

#pragma mark -  获取用户活动信息
+ (RACSignal *)request_UserActivityWithParameter:(NSDictionary *)parameter{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"activity/getUserActivity"
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

#pragma mark - 活动操作
+ (RACSignal *)request_ExecuteActivityWithParameter:(NSDictionary *)parameter{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"activity/executeActivity"
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


#pragma mark -  VIN服务商列表

+ (RACSignal *)request_VINServiceListWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"vin/serviceList"
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

#pragma mark -  VIN服务商套餐价格列表

+ (RACSignal *)request_VINServicePriceListWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"vin/priceList"
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

#pragma mark -  VIN查询
+ (RACSignal *)request_GetVINDiffModelsWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"vin/getDiffModels"
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

+ (RACSignal *)request_BuyVINServiceWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"vin/vinQuery"
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

#pragma mark -  VIN服务套餐下订单

+ (RACSignal *)request_VINServiceCreateRechargeWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"vin/createOrder"
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

#pragma mark -  VIN服务商剩余次数

+ (RACSignal *)request_VINBalanceWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"vin/getBalance"
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


#pragma mark -  VIN查询列表

+ (RACSignal *)request_VINListWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"vin/vinQueryList"
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

#pragma mark -  VIN查询历史详情
+ (RACSignal *)request_VINDetailWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"vin/vinQueryDetail"
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
