
//
//  GGOrderDetailViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOrderDetailViewModel.h"

@interface GGOrderDetailViewModel ()

@property(nonatomic,copy)NSString *dynamicCode;

@end

@implementation GGOrderDetailViewModel

- (void)initialize{

    @weakify(self);

    //详情数据
    _detailDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        @strongify(self);
        return [[GGApiManager request_PaymentOrderDetailsWithParames:@{@"orderNo":self.orderNo,@"typeId":input}]map:^id(NSDictionary *value) {
            @strongify(self);
            self.orderDetail = [GGOrderDetails modelWithDictionary:value];
            return [RACSignal empty];
        }];
    }];
    
    //买家确认收货
    _confirmGoodsCommand  = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *password) {
        
        return [[[GGApiManager request_GetDynamicCode] map:^id(NSString *value) {
            @strongify(self);
            self.dynamicCode = value;
            return [RACSignal empty];
        }]then:^RACSignal *{
            @strongify(self);
            NSArray *array = @[self.orderNo,
                               [GGLogin shareUser].token,
                               self.dynamicCode,
                               password];
            
            NSString *payPassword = [[GGHttpSessionManager sharedClient].rsaSecurity
                                     rsaEncryptString:[array componentsJoinedByString:@""]];
            
            return [[GGApiManager request_BuyerConfirmGoodsWithParames:@{@"orderNo":self.orderNo,@"payPassword":payPassword}] map:^id(id value) {
                return [RACSignal empty];
            }];
            
        }];
    }];

    
    //卖家收到退货(收到买家的退货)
    _sellerConfirmGoodsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *password) {
        @strongify(self);
        NSArray *array = @[self.orderDetail.orderNo,[GGLogin shareUser].token,password];
        NSString *payPassword = [[GGHttpSessionManager sharedClient].rsaSecurity
                                 rsaEncryptString:[array componentsJoinedByString:@""]];
        return [[GGApiManager request_SealerConfirmGoodsWithParames:@{@"orderNo" : self.orderDetail.orderNo,@"payPassword":payPassword}] map:^id(id value) {
            return [RACSignal empty];
        }];
    }];
}

@end
