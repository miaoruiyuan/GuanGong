
//
//  GGCheckCarSeriesViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckCarSeriesViewModel.h"

@implementation GGCheckCarSeriesViewModel

- (void)initialize{
    
}


- (RACCommand *)brandCommand{
    if (!_brandCommand) {
        @weakify(self);
        _brandCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
            return [[GGApiManager request_CarBrandsList]map:^id(NSArray *value) {
                NSArray *models = [NSArray modelArrayWithClass:[GGCarBrand class] json:value];
                
                NSMutableDictionary *mDic  = [NSMutableDictionary dictionary];
                for (GGCarBrand *brand in models) {
                    NSMutableArray *mArr = mDic[brand.pinyin_initial];
                    if (!mArr) {
                        mArr = [NSMutableArray array];
                        [mDic setObject:mArr forKey:brand.pinyin_initial];
                    }
                    [mArr addObject:brand];
                }
                
                if ([input isEqualToNumber:@1]) {
                    GGCarBrand *brand = [[GGCarBrand alloc] init];
                    brand.name = @"不限品牌";
                    [mDic setObject:[NSArray arrayWithObject:brand] forKey:@"*"];
                }
                @strongify(self);
                self.brands = mDic;
                return [RACSignal empty];
            }];
            
        }];
    }
    return _brandCommand;
}




- (RACCommand *)seriesCommand{
    if (!_seriesCommand) {
        @weakify(self);
        _seriesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
            
            @strongify(self);
            return [[GGApiManager request_CarSeriesListWithBrandId:self.brandId]map:^id(NSArray *value) {
                NSMutableArray *seriesArr =  [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[GGCarSeries class] json:value]];
                
                if ([input isEqualToNumber:@1]) {
                    GGCarSeries *seriesObj = [[GGCarSeries alloc] init];
                    seriesObj.car_mfrs.iautos_name = @"*";
                    GGSeries *ser = [[GGSeries alloc] init];
                    ser.name_show = @"不限车系";
                    seriesObj.car_series = [NSArray arrayWithObject:ser];
                    [seriesArr insertObject:seriesObj atIndex:0];
                }
                
                @strongify(self);
                self.series = seriesArr;

                return [RACSignal empty];
            }];
            
        }];
    }
    return _seriesCommand;
}






@end
