//
//  CWTSearchVinViewModel.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/20.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTSearchVinViewModel.h"
#import "GGApiManager+Vin.h"

@implementation CWTSearchVinViewModel

- (void)initialize{
    
    @weakify(self);
    _serviceListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[GGApiManager request_CarHistoryServiceListWithParameter:@{}] map:^id(id value) {
            @strongify(self);
            NSArray *array = value[@"result"];
            if (array.count > 0) {
                self.serviceCompany = [GGCarHistoryServiceCompany modelWithJSON:array[0]];
            }else{
                return [RACSignal error:nil];
            }
            return [RACSignal empty];
        }];
    }];
    
    _carHistoryBalanceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSString *serviceKey = self.serviceCompany.key;
        if (!serviceKey) {
            return [RACSignal error:nil];
        }
        
        return [[GGApiManager request_CarHistoryBalanceWithParameter:@{@"serviceKey":serviceKey}] map:^id(id value) {
            @strongify(self);
            self.balance = value[@"balance"];
            return [RACSignal empty];
        }];
    }];
    
    _buyCarHistoryCommand  = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSString *serviceKey = self.serviceCompany.key;
        if (!serviceKey) {
            return [RACSignal error:nil];
        }
        NSDictionary *dic = @{@"vin":self.vin,
                              @"serviceKey":serviceKey};
        return [[GGApiManager request_BuyCarHistoryServiceWithParameter:dic] map:^id(id value) {
            @strongify(self);
            self.reportDetailModel = [GGCarHistoryReportDetailModel modelWithJSON:value];
            return [RACSignal empty];
        }];
    }];
}

@end
