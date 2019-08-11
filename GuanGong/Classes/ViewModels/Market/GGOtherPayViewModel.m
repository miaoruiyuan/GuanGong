//
//  GGOtherPayModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOtherPayViewModel.h"

@implementation GGOtherPayViewModel

- (void)initialize{
    
    @weakify(self);
    self.loadData = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        @strongify(self);
        NSDictionary *dic = @{@"page":self.willLoadMore ? [NSNumber numberWithInteger:self.pageIndex + 1] : @1,
                              @"pageSize":@20,
                              @"flag":input,
                              @"status":self.status == OtherPayStatusNone ? @"" : @(self.status)};
        
        return [[GGApiManager request_ApplyListWithParames:dic]map:^id(NSDictionary *value) {
            NSArray *array =[NSArray modelArrayWithClass:[GGOtherPayList class] json:value[@"result"]];
            @strongify(self);
            
            if (array.count > 0) {
                if (!self.willLoadMore) {
                    [self.dataSource removeAllObjects];
                }
                
                [self.dataSource addObjectsFromArray:array];
                
                self.totalCount = value[@"totalRecord"];
                self.canLoadMore = self.dataSource.count < self.totalCount.integerValue;
            }else{
                self.canLoadMore = NO;
                if (!self.willLoadMore) {
                    [self.dataSource removeAllObjects];
                }
            }
            
            self.pageIndex = [value[@"pageNo"]integerValue];
            return [RACSignal empty];
        }];

    
    }];

}



@end
