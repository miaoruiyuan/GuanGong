//
//  GGVinInfoViewModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGVinInfoViewModel.h"
#import "GGApiManager+Vin.h"
#import "CWTVinResult.h"

@implementation GGVinInfoViewModel

- (void)initialize{
    
    @weakify(self);
    _vinInfoBalanceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {

        return [[GGApiManager request_VINBalanceWithParameter:@{}] map:^id(id value) {
            @strongify(self);
            if ([value[@"balance"] isKindOfClass:[NSNumber class]]){
                self.balance = value[@"balance"];
                return [RACSignal empty];
            }
            return [RACSignal error:nil];
        }];
    }];
    
    _vinGetDiffModelsCommand  = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSDictionary *dic = @{@"vin":self.vin};
        return [[GGApiManager request_GetVINDiffModelsWithParameter:dic] map:^id(id value) {

            @strongify(self);
            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in value) {
                CWTVinResult *vinModel = [CWTVinResult modelWithJSON:dic];
                if (vinModel) {
                    NSMutableArray *configArray = [[NSMutableArray alloc] init];
                    for (NSString *configItem in vinModel.config) {
                        if (configItem.length > 0 ) {
                            [configArray addObject:configItem];
                        }
                    }
                    vinModel.config = configArray;
                    vinModel.vin = self.vin;
                    [result addObject:vinModel];
                }
            }
            self.vinResults = [NSArray arrayWithArray:result];
            return [RACSignal empty];
        }];
    }];
    
    _buyVinInfoCommand  = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(CWTVinResult *vinResult) {
        NSString *moreChoose = @"0";
        if (vinResult.moreChoose) {
            moreChoose = @"1";
        }
        NSDictionary *dic = @{@"vin":vinResult.vin,
                              @"modelId":vinResult.trimId,
                              @"modelName":vinResult.trimName,
                              @"moreChoose":moreChoose
                              };
        return [[GGApiManager request_BuyVINServiceWithParameter:dic] map:^id(id value) {
            @strongify(self);
            self.vinInfoDetail = [GGVinResultDetailModel modelWithDictionary:value];
            return [RACSignal empty];
        }];
    }];

    _getVinInfoDetailCommand  = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *vinQueryId) {
        NSDictionary *dic = @{@"vinQueryId":vinQueryId};
        return [[GGApiManager request_VINDetailWithParameter:dic] map:^id(id value) {
            @strongify(self);
            self.vinInfoDetail = [GGVinResultDetailModel modelWithDictionary:value];
            return [RACSignal empty];
        }];
    }];

}

@end
