//
//  GGVehicleMagmentViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGVehicleMagmentViewModel.h"

@implementation GGVehicleMagmentViewModel

- (void)initialize{
    
    @weakify(self);
    
    self.loadData = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        
        @strongify(self);
        self.parameter.status = @"5";
        if (!_isCarsList) {
             self.parameter.status = [input isEqualToNumber:@3] ? @"2,3,8,9,10" : input.stringValue;
        }
        
        self.parameter.pageNo = self.willLoadMore ? [NSNumber numberWithInteger:self.pageIndex + 1] : @1;
        NSDictionary *dic = [self.parameter modelToJSONObject];

        return [[GGApiManager request_vehicleManagerListWithParameter:dic]map:^id(NSDictionary *value) {
            @strongify(self);
            if (!self.willLoadMore) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:[NSArray modelArrayWithClass:[GGVehicleList class] json:value[@"list"]]];
            self.totalCount = value[@"totalRecord"];
            self.canLoadMore = self.dataSource.count < self.totalCount.integerValue;
            
            self.pageIndex = [value[@"pageNo"] integerValue];
            return [RACSignal empty];
        }];
    }];
    
    
    //车辆详情
    _carDetailsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        return [[GGApiManager request_carDetailsWithCarId:input] map:^id(NSDictionary *value) {
            @strongify(self);
            self.car = [GGCar modelWithDictionary:value];
            NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:self.car.photosList.count];
            NSMutableArray *mediumUrlArray = [NSMutableArray arrayWithCapacity:self.car.photosList.count];
            for (int i = 0; i < self.car.photosList.count; i ++) {
                if ([self.car.photosList[i]objectForKey:@"url"]) {
                    NSString *url = [self.car.photosList[i] objectForKey:@"url"];
                    NSString *mediumUrl = [self.car.photosList[i] objectForKey:@"mediumUrl"];
                    [urlArray addObject:url];
                    [mediumUrlArray addObject:mediumUrl];
                }
            }
            self.car.vinUsed = YES;
            self.car.photosList = urlArray;
            self.car.mediumUrlList = mediumUrlArray;
            return [RACSignal empty];
        }];
    }];
    
    
    //删除车辆
    _deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        return [[GGApiManager request_deleteCarByCarId:input] map:^id(NSNumber *value) {
            return [RACSignal empty];
        }];
    }];
    
    //注册筛选通知
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:GGCarsListParameterNotification object:nil] deliverOnMainThread] subscribeNext:^(NSNotification *info) {
        @strongify(self);
        if ([info.object isKindOfClass:NSClassFromString(@"GGLocationViewController")]) {
            self.parameter.provinceId = info.userInfo[@"provinceId"];
            self.parameter.cityId = info.userInfo[@"cityId"];
        }
        
        if ([info.object isKindOfClass:NSClassFromString(@"GGCarModelViewController")]) {
            self.parameter.brandId = info.userInfo[@"brandId"];
            self.parameter.seriesId = info.userInfo[@"seriesId"];
        }
        
        if ([info.object isKindOfClass:NSClassFromString(@"GGPriceViewController")]) {
            self.parameter.priceMax = info.userInfo[@"priceMax"];
            self.parameter.priceMin = info.userInfo[@"priceMin"];
        }
        
        if ([info.object isKindOfClass:NSClassFromString(@"GGSortViewController")]) {
            self.parameter.sort = info.userInfo[@"sort"];
        }
        self.notification = info;
    }];
}

- (Parameter *)parameter{
    if (!_parameter) {
        _parameter = [[Parameter alloc] init];
        _parameter.userId = _isCarsList ? nil : [GGLogin shareUser].user.userId;
        _parameter.pageSize = @15;
    }
    return _parameter;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



@implementation Parameter


@end
