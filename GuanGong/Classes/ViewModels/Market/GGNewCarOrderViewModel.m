//
//  GGNewCarOrderViewModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/10.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGNewCarOrderViewModel.h"
#import "GGApiManager+Vin.h"

@implementation GGNewCarOrderViewModel

- (void)initialize
{
    @weakify(self);
    _carOrderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *carCount) {
        @strongify(self);
        
        NSInteger logisticsType = self.carDetailModel.logisticsType;
        NSDictionary *dic = @{@"id":self.carDetailModel.carId,
                              @"logisticsType":@(logisticsType), //物流类型 1 自取
                              @"carQuantity":carCount};
        return [[GGApiManager request_GetNewCarOrderWithParameter:dic] map:^id(NSDictionary *value) {
            @strongify(self);
            self.carOrderDetail = [GGCarOrderDetail modelWithDictionary:value];
            DLog(@"%@",self.carOrderDetail);
            return [RACSignal empty];
        }];
    }];
}

@end
