//
//  GGVinInfoServicePriceViewModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGVinInfoServicePriceViewModel.h"
#import "GGApiManager+Vin.h"
#import "GGSearvicePriceListModel.h"

@implementation GGVinInfoServicePriceViewModel

- (void)initialize{
    @weakify(self);
    _servicePriceListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[GGApiManager request_VINServicePriceListWithParameter:@{}] map:^id(id value) {
            @strongify(self);
            NSArray *array = [NSArray modelArrayWithClass:[GGSearvicePriceListModel class] json:value];
            self.dataSource = [array mutableCopy];
            return [RACSignal empty];
        }];
    }];
    
    _createRechargeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *priceId) {
        NSDictionary *dic = @{@"priceId":priceId};
        return [[GGApiManager request_VINServiceCreateRechargeWithParameter:dic] map:^id(id value) {
            @strongify(self);
            self.orderModel = [GGCarHistoryRechargeOrderModel modelWithJSON:value];
            return [RACSignal empty];
        }];
    }];
}

@end
