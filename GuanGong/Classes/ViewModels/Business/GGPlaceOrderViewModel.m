//
//  GGPlaceOrderViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPlaceOrderViewModel.h"

@implementation GGPlaceOrderViewModel

- (void)initialize
{
    
    @weakify(self);
    _placeOrderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
     
        @strongify(self);
        NSDictionary *dic = @{@"carId":self.car.carId,@"logisticsType":@1};
        
        return [[GGApiManager request_placeAnCarOrderWithParameter:dic] map:^id(NSDictionary *value) {
            @strongify(self);
            self.carOrderDetail = [GGCarOrderDetail modelWithDictionary:value];
            return [RACSignal empty];
        }];
    }];
    
}

@end
