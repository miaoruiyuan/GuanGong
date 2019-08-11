
//
//  GGCheckOrderViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckOrderViewModel.h"

@implementation GGCheckOrderViewModel

- (void)initialize{
    
    @weakify(self);
    self.loadData = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        
        @strongify(self);
        NSDictionary *dic = nil;
        if (input.integerValue < 0) {
            dic = @{@"page":self.willLoadMore ? [NSNumber numberWithInteger:self.pageIndex + 1] : @1,
                    @"pageSize":@20};
            
        }else{
            dic = @{@"page":self.willLoadMore ? [NSNumber numberWithInteger:self.pageIndex + 1] : @1,
                    @"pageSize":@20,
                    @"orderStatus":input};
            
        }
        
        
        return [[GGApiManager request_checkCarOrderWithParames:dic]map:^id(NSDictionary *value) {
            NSArray *models = [NSArray modelArrayWithClass:[GGCheckOrderList class] json:value[@"result"]];
            
            @strongify(self);
            if (models && models.count > 0) {
                if (!self.willLoadMore) {
                    [self.dataSource removeAllObjects];
                }
                [self.dataSource addObjectsFromArray:models];
                
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
