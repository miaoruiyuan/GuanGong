//
//  GGNewCarListViewModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/9.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGNewCarListViewModel.h"
#import "GGNewCarListModel.h"
#import "GGApiManager+Vin.h"

@implementation GGNewCarListViewModel

- (void)initialize
{
    
    @weakify(self);
    self.loadData = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
     
        @strongify(self);
        NSNumber *pageNo = self.willLoadMore ? [NSNumber numberWithInteger:self.pageIndex + 1] : @1;
        NSDictionary *dic = @{@"pageNo":pageNo,
                              @"status":@"3"};//status 3 在售
        
        if (self.cityID && self.provinceID) {
            dic = @{@"pageNo":pageNo,
                    @"status":@"3",
                    @"cityId":self.cityID,
                    @"provinceId":self.provinceID};
        }
    
        return [[GGApiManager request_GetNewCarListWithParameter:dic] map:^id(NSDictionary *value) {
            @strongify(self);
            if (!self.willLoadMore) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:[NSArray modelArrayWithClass:[GGNewCarListModel class] json:value[@"list"]]];
            self.totalCount = value[@"totalRecord"];
            self.canLoadMore = self.dataSource.count < self.totalCount.integerValue;
            self.pageIndex = [value[@"pageNo"] integerValue];
            return [RACSignal empty];
        }];
    }];
}

#pragma mrark - UITableView

- (NSInteger)sectionCount
{
    return 1;
}

- (NSInteger)itemCountAtSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (GGNewCarListModel *)itemForIndexPath:(NSIndexPath *)indexPath
{
    return self.dataSource[indexPath.row];
}

@end
