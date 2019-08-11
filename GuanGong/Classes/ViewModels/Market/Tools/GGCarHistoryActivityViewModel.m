//
//  GGCarHistoryActivityViewModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/18.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGCarHistoryActivityViewModel.h"
#import "GGApiManager+Vin.h"

@implementation GGCarHistoryActivityViewModel

- (void)initialize
{
    @weakify(self);
    _getActivityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *activityFlag) {
        @strongify(self);
        NSString *activityId = @"1";
        if (self.activityId) {
            activityId = self.activityId;
        }

        //1-绑卡成功赠送车史查询4次；2-实名认证赠送车史查询2次；3-实名认证赠送VIN查询10次；4-绑卡成功赠送VIN查询20次
        NSDictionary *dic = @{@"activityId":activityId
                              };
        return [[GGApiManager request_UserActivityWithParameter:dic] map:^id(id value) {
            @strongify(self);
            self.activityModel = [GGUserActivityModel modelWithJSON:value];
            return [RACSignal empty];
        }];
    }];

    
    _executeActivityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *activityFlag) {
        @strongify(self);
        NSString *activityId = @"1";
        if (self.activityId) {
            activityId = self.activityId;
        }
        NSDictionary *dic = @{@"activityId":activityId,
                              @"flag":activityFlag
                              };
        return [[GGApiManager request_ExecuteActivityWithParameter:dic] map:^id(id value) {
            return [RACSignal empty];
        }];
    }];
}

@end
