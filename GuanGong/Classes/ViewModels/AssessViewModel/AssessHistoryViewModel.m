//
//  AssessHistoryViewModel.m
//  bluebook
//
//  Created by three on 2017/5/11.
//  Copyright © 2017年 iautos_miaoruiyuan. All rights reserved.
//

#import "AssessHistoryViewModel.h"
#import "GGToolApiManager.h"
#import "CWTAssess.h"

@interface AssessHistoryViewModel ()

@end

@implementation AssessHistoryViewModel

-(void)initialize
{
    [super initialize];
    [self initBind];
}

-(void)initBind{
    
    @weakify(self);
    _historyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        @strongify(self);
        NSDictionary *dic = @{@"page":self.willLoadMore ? @(self.pageIndex + 1): @1,
                              @"user_id" : [GGLogin shareUser].user.userId};
        
        return [[GGToolApiManager carPriceAssessHistoryWithParames:dic] map:^id(NSDictionary *value) {

            @strongify(self);
            if (!self.willLoadMore) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:[NSArray modelArrayWithClass:[CWTAssess class] json:value[@"list"]]];
            self.totalCount = value[@"total_count"];
            self.pageIndex = [value[@"page"] integerValue];
            self.canLoadMore = self.dataSource.count < [self.totalCount integerValue];
            
            return [RACSignal empty];
        }];
    }];
    
    _assessCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        @strongify(self);

        params[@"user_id"] = [GGLogin shareUser].user.userId;
        params[@"purchase_year"] = self.assess.purchase_year;
        params[@"model_simple_id"] = self.assess.model_simple_id;
        params[@"mileage"] = self.assess.mileage;
        params[@"first_reg_date"] = self.assess.first_reg_date;
        params[@"log_id"] = input;
        
        if (self.assess.city_id == nil) {
            self.assess.city_id = @"828";
        }
        params[@"city_id"] = self.assess.city_id;
        
        return [[GGToolApiManager carPriceAssessWithParames:params] map:^id(id value) {
            @strongify(self);

            self.assessResult = [CWTAssessResult modelWithDictionary:value];
            self.assessResult.city_id = self.assess.city_id;
            self.assessResult.model_simple_id = self.assess.model_simple_id;
            self.assessResult.purchase_year = self.assess.purchase_year;
            
            return [RACSignal empty];
        }];
        
    }];
}

@end
