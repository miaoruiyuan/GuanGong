//
//  GGToolApiManager.m
//  GuanGong
//
//  Created by CodingTom on 2017/3/27.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGToolApiManager.h"
#import "CWTNetClient.h"

static GGToolApiManager *shared_manager = nil;

@implementation GGToolApiManager

+ (instancetype)sharedManager{
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

#pragma mark - 旧车评估
+ (RACSignal *)carPriceAssessWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[CWTNetClient shareClient] requestWithPath:@"iautosapp/pinggu/pinggu"
                                     withParams:parames
                                     withMethodType:Get
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

#pragma mark - 评估历史
+ (RACSignal *)carPriceAssessHistoryWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[CWTNetClient shareClient] getWithPath:@"iautosapp/pinggu/history"
                                     withParams:parames
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

#pragma mark - 保值率查询,车系
+ (RACSignal *)carComputeWithSeries:(NSNumber *)seriesId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[CWTNetClient shareClient] getWithPath:@"car/hedge_ratio/series"
                                     withParams:@{@"series_id" : seriesId}
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

+ (RACSignal *)searchDischargeCityWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[CWTNetClient shareClient] getWithPath:@"car/topic_entry_standard/search"
                                     withParams:parames
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
