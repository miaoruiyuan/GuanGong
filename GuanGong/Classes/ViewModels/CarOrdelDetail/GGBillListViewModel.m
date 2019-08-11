//
//  GGBillListViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/15.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBillListViewModel.h"

@interface GGBillListViewModel ()

@property (nonatomic,strong)NSMutableDictionary *dataSourceDic;

@end

@implementation GGBillListViewModel

@synthesize loadData = _loadData;

- (void)initialize
{
    [super initialize];
    self.dataSourceDic = [[NSMutableDictionary alloc] init];
}

- (RACCommand *)loadData
{
    if (!_loadData) {
        
        @weakify(self);
        _loadData = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            NSNumber *pageNum = self.willLoadMore ? @(self.billList.pageNo + 1) : @1;
            NSDictionary *dic;
            if (self.otherUserId) {
                dic = @{@"otherUserId":self.otherUserId,
                        @"pageNum":pageNum
                        };
            } else {
                dic = @{@"pageNum":pageNum};
            }
            
            return [[GGApiManager request_BillLists_WithParmas:dic] map:^id(id value) {
                @strongify(self);
                self.billList = [GGBillList modelWithDictionary:value];
                [self createTableDataSource];
                self.canLoadMore = self.billList.pageNo <= self.billList.totalPage;
                return [RACSignal empty];
            }];
        }];

    }
    return _loadData;
}

- (NSInteger)itemCountAtSection:(NSInteger)section
{
    NSArray *billArray = self.dataSourceDic[self.dataSource[section]];
    return billArray.count;
}

- (GGBillList *)itemForIndexPath:(NSIndexPath *)indexPath
{
    NSArray *billArray = self.dataSourceDic[self.dataSource[indexPath.section]];
    return billArray[indexPath.row];
}

- (void)createTableDataSource
{
    if (!self.willLoadMore) {
        [self.dataSource removeAllObjects];
        [self.dataSourceDic removeAllObjects];
    }

    for (BillItem *itemModel in self.billList.result) {
        if (!itemModel.tranDateMonth) {
            itemModel.tranDateMonth = @" ";
        }
        if (self.dataSourceDic[itemModel.tranDateMonth]) {
            [self.dataSourceDic[itemModel.tranDateMonth] addObject:itemModel];
        } else {
            [self.dataSource addObject:itemModel.tranDateMonth];
            [self.dataSourceDic setObject:[@[itemModel] mutableCopy] forKey:itemModel.tranDateMonth];
        }
    }
}

- (NSString *)getSectionTitle:(NSUInteger)section
{
    NSString *dataStr = self.dataSource[section];
    NSArray *separatedArray = [dataStr componentsSeparatedByString:@"-"];
    if (separatedArray.count == 2) {
        NSString *month = separatedArray[1];
        if ([month hasPrefix:@"0"]) {
            month = [month substringFromIndex:1];
        }
        return [NSString stringWithFormat:@"%@年%@月",separatedArray[0],month];
    }
    return dataStr;
}

@end
