//
//  GGBusinessViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBusinessViewModel.h"

@interface GGBusinessViewModel ()

@property(nonatomic,strong)NSArray *configArray;

@end

@implementation GGBusinessViewModel

- (void)initialize
{
    @weakify(self);
    self.loadData = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        return [[GGApiManager request_getBusinessDataWithParameter:@{}] map:^id(NSDictionary *value){
            @strongify(self);
            GGBusinessHome *item  = [GGBusinessHome modelWithJSON:value];
            self.homeData = item;
            return [RACSignal empty];
        }];
    }];
}

//POST /ggApi/business/home







@end
