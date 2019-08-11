
//
//  GGRewardViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/16.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGRewardViewModel.h"

@interface GGRewardViewModel ()

@property(nonatomic,copy)NSString *dynamicCode;

@end

@implementation GGRewardViewModel

- (void)initialize{
    //打赏按钮
    _enbleRewardSignal = [RACSignal combineLatest:@[RACObserve(self, tranAmount)] reduce:^id(NSString *price){
        return @(price.length > 0);
    }];    
}


#pragma mark - 获取打赏信息
- (RACCommand *)rewardInfoCommond{
    if (!_rewardInfoCommond) {
        @weakify(self);
        _rewardInfoCommond = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [[GGApiManager request_RewardInfo]map:^id(NSDictionary *value) {
                @strongify(self);
                self.rewardInfo = [RewardInfo modelWithDictionary:value];
                return [RACSignal empty];
            }];
        }];
    }
    return _rewardInfoCommond;
}

#pragma marlk - 打赏
- (RACCommand *)rewardCommond{
    if (!_rewardCommond) {
        @weakify(self);
        _rewardCommond = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
            return [[[GGApiManager request_GetDynamicCode]map:^id(NSString *value) {
                @strongify(self);
                self.dynamicCode = value;
                return [RACSignal empty];
            }]then:^RACSignal *{
                @strongify(self);
                NSArray *array = @[self.orderNo,
                                   @2,
                                   @40,
                                   self.tranAmount,
                                   self.rewardInfo.userId,
                                   [GGLogin shareUser].token,
                                   self.dynamicCode,
                                   @6,
                                   input];
                
                NSString *payPassword = [[GGHttpSessionManager sharedClient].rsaSecurity
                                         rsaEncryptString:[array componentsJoinedByString:@""]];
                
                NSDictionary *dic = @{@"orderNo":self.orderNo,
                                      @"tranAmount":self.tranAmount,
                                      @"payPassword":payPassword};
                
                return [[GGApiManager request_RewardWithParames:dic] map:^id(NSDictionary *value) {
                    return [RACSignal empty];
                }];
            }];
        }];
    }
    return _rewardCommond;
}

@end

@implementation RewardInfo

@end
