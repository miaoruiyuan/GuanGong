//
//  CWTVinHistoryViewModel.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/21.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTVinHistoryViewModel.h"
#import "GGTablePageModel.h"
#import "GGApiManager+Vin.h"
#import "CWTMaintainHistory.h"
#import "CWTVinHistory.h"

@interface CWTVinHistoryViewModel()

@property (nonatomic,strong) GGTablePageModel *tablePageModel;

@end

@implementation CWTVinHistoryViewModel

@synthesize carHistoryListCommand = _carHistoryListCommand;
@synthesize carHistoryDetailCommand = _carHistoryDetailCommand;

@synthesize vinInfoListCommand = _vinInfoListCommand;
@synthesize vinInfoDetailCommand = _vinInfoDetailCommand;

- (void)initialize{
    

}

#pragma mark - 维修保养

- (RACCommand *)carHistoryDetailCommand
{
    if (!_carHistoryDetailCommand) {
        @weakify(self);
        _carHistoryDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *reportID) {
            NSDictionary *dic = @{@"reportId":reportID};
            return [[GGApiManager request_CarHistoryDetailWithParameter:dic] map:^id(id value) {
                @strongify(self);
                self.reportDetailModel = [GGCarHistoryReportDetailModel modelWithJSON:value];
                return [RACSignal empty];
            }];
        }];
    }
    return _carHistoryDetailCommand;
}

- (RACCommand *)carHistoryListCommand
{
    if (!_carHistoryListCommand) {
        //保养历史记录
        @weakify(self);
        _carHistoryListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
            @strongify(self);
            NSNumber *pageNo = self.willLoadMore ? @([self.tablePageModel.pageNo integerValue] + 1) : @1;
            
            NSDictionary *dic = @{@"pageNo":pageNo,
                                  @"pageSize":@"20"
                                  };
            
            return [[GGApiManager request_CarHistoryListWithParameter:dic] map:^id(id value) {
                @strongify(self);
                self.tablePageModel = [GGTablePageModel modelWithJSON:value];
                NSArray *resultArray = [NSArray modelArrayWithClass:[CWTMaintainHistory class] json:value[@"result"]];
                if (self.willLoadMore) {
                    [self.dataSource addObjectsFromArray:resultArray];
                } else {
                    self.dataSource = [NSMutableArray arrayWithArray:resultArray];
                }
                self.tablePageModel.currentPageSize = [resultArray count];
                self.canLoadMore = [self.tablePageModel showLoadMoreView];
                return [RACSignal empty];
            }];
        }];
    }
    return _carHistoryListCommand;
}

#pragma mark - VIN Info

- (RACCommand *)vinInfoDetailCommand
{
    if (!_vinInfoDetailCommand) {
        @weakify(self);
        _vinInfoDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *vinQueryId) {
            NSDictionary *dic = @{@"vinQueryId":vinQueryId};
            return [[GGApiManager request_VINDetailWithParameter:dic] map:^id(id value) {
                @strongify(self);
                self.vinInfoDetailModel = [GGVinResultDetailModel modelWithDictionary:value];
                return [RACSignal empty];
            }];
        }];
    }
    return _vinInfoDetailCommand;
}

- (RACCommand *)vinInfoListCommand
{
    if (!_vinInfoListCommand) {
        @weakify(self);
        _vinInfoListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
            @strongify(self);
            NSNumber *pageNo = self.willLoadMore ? @([self.tablePageModel.pageNo integerValue] + 1) : @1;
            
            NSDictionary *dic = @{@"pageNo":pageNo,
                                  @"pageSize":@"20"
                                  };
            
            return [[GGApiManager request_VINListWithParameter:dic] map:^id(id value) {
                @strongify(self);
                self.tablePageModel = [GGTablePageModel modelWithJSON:value];
                NSArray *resultArray = [NSArray modelArrayWithClass:[CWTVinHistory class] json:value[@"result"]];
                if (self.willLoadMore) {
                    [self.dataSource addObjectsFromArray:resultArray];
                } else {
                    self.dataSource = [NSMutableArray arrayWithArray:resultArray];
                }
                self.tablePageModel.currentPageSize = [resultArray count];
                self.canLoadMore = [self.tablePageModel showLoadMoreView];
                return [RACSignal empty];
            }];
        }];
    }
    return _vinInfoListCommand;
}

@end
