//
//  GGCarModelViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarModelViewModel.h"

@implementation GGCarModelViewModel



- (RACCommand *)yearsCommand{
    if (!_yearsCommand) {
        @weakify(self);
        _yearsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [[GGApiManager request_CarYearsListWithSeriesId:input]map:^id(NSArray *value) {
                @strongify(self);
                self.years = value;
                return [RACSignal empty];
            }];
            
        }];
    }
    return _yearsCommand;
}

- (RACCommand *)modelsCommand{
    if (!_modelsCommand) {
        @weakify(self);
        _modelsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [[GGApiManager request_CarModelsListWithSeriesId:self.seriesId purYear:input]map:^id(NSArray *value) {
                @strongify(self);
                NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:value.count];
                for (int i = 0; i < value.count ; i ++) {
                    GGModelList *item  = [GGModelList modelWithJSON:value[i]];
                    item.brand_id = self.brandId;
                    item.series_id = self.seriesId;
                    [mArr addObject:item];
                }
                self.models = mArr;
    
                return [RACSignal empty];
            }];
            
        }];
    }
    return _modelsCommand;
}



@end
