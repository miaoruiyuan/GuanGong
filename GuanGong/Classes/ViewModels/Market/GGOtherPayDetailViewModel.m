//
//  GGOtherPayDetailViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOtherPayDetailViewModel.h"

@interface GGOtherPayDetailViewModel ()

@property(nonatomic,copy)NSString *dynamicCode;

@end

@implementation GGOtherPayDetailViewModel

- (void)initialize{
    
    @weakify(self);
    _applyDetailCommand  = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        return [[GGApiManager request_ApplyDetailWithApplyId:input] map:^id(NSDictionary *value) {
            @strongify(self);
            self.otherPayDetail = [GGOtherPayDetail modelWithDictionary:value];
            return [RACSignal empty];
        }];
    }];
    
    //取消/拒绝代付
    _cancelApplyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        return [[GGApiManager request_CancelApplyWithApplyId:input] map:^id(id value) {
            return [RACSignal empty];
        }];
    }];
    
    //同意代付
    _agreeApplyCommand  = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
    
        return [[[GGApiManager request_GetDynamicCode] map:^id(NSString *value) {
            @strongify(self);
            self.dynamicCode = value;
            return [RACSignal empty];
        }] then:^RACSignal *{
            
            @strongify(self);

            RACTupleUnpack(NSNumber *applyId,NSString *password) = input;
            
            NSArray *array = @[self.otherPayDetail.orderNo ? : @"",
                               @2,
                               self.otherPayDetail.goodsStatusId,
                               self.otherPayDetail.amount, 
                               self.otherPayDetail.saler.salerId,
                               [GGLogin shareUser].token,
                               self.dynamicCode,
                               @1,
                               password];
        
            NSString *payPassword = [[GGHttpSessionManager sharedClient].rsaSecurity
                                     rsaEncryptString:[array componentsJoinedByString:@""]];
            
            return [[GGApiManager request_AgreeApplyWithParames:@{@"id":applyId,
                                                                  @"payPassword":payPassword}]map:^id(NSDictionary *value) {
                return [RACSignal empty];
            }];
        }];
    }];
}

@end
