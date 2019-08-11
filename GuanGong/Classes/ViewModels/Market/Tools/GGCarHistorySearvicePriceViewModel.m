//
//  GGCarHistorySearvicePriceViewModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/12.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGCarHistorySearvicePriceViewModel.h"
#import "GGSearvicePriceListModel.h"
#import "GGApiManager+Vin.h"

@implementation GGCarHistorySearvicePriceViewModel

- (void)initialize{
    @weakify(self);
    _servicePriceListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[GGApiManager request_CarHistoryServicePriceListWithParameter:@{@"serviceKey":self.serviceCompany.key}] map:^id(id value) {
            @strongify(self);
            NSArray *array = [NSArray modelArrayWithClass:[GGSearvicePriceListModel class] json:value];
            self.dataSource = [array mutableCopy];
            return [RACSignal empty];
        }];
    }];
    
    _createRechargeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *priceId) {
        @strongify(self);
        NSDictionary *dic = @{@"serviceKey":self.serviceCompany.key,
                              @"priceId":priceId};
        return [[GGApiManager request_CarHistoryServiceCreateRechargeWithParameter:dic] map:^id(id value) {
            @strongify(self);
            self.orderModel = [GGCarHistoryRechargeOrderModel modelWithJSON:value];
            return [RACSignal empty];
        }];
    }];
}

@end
