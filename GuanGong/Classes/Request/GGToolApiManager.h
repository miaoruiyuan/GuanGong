//
//  GGToolApiManager.h
//  GuanGong
//
//  Created by CodingTom on 2017/3/27.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGToolApiManager : NSObject

#pragma mark - 旧车评估
+ (RACSignal *)carPriceAssessWithParames:(NSDictionary *)parames;

#pragma mark - 新车评估
+ (RACSignal *)carPriceAssessHistoryWithParames:(NSDictionary *)parames;

#pragma mark - 保值率查询,车系
+ (RACSignal *)carComputeWithSeries:(NSNumber *)seriesId;

+ (RACSignal *)searchDischargeCityWithParames:(NSDictionary *)parames;

@end
