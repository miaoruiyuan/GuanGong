//
//  GGInvitationRecordViewModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/3/22.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGInvitationRecordViewModel.h"

@interface GGInvitationRecordViewModel()

@property (nonatomic,assign)NSUInteger pageNo;

@end

@implementation GGInvitationRecordViewModel

@synthesize loadData = _loadData;

- (void)initialize
{
//    GGInvite *test  = [[GGInvite alloc] init];
//    test.mobilePhone = @"15010203067";
//    test.updateTime = @"140203203200";
//    test.realName = @"路裕杰";
//    self.dataSource = [@[test] mutableCopy];
}

- (RACCommand *)loadData{
    if (!_loadData) {
        @weakify(self);
        _loadData = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            @strongify(self);
            NSNumber *pageNum = self.willLoadMore ? @(self.pageNo + 1) : @1;
            NSDictionary *dic = @{@"page":pageNum,@"pageSize":@30};
            
            return [[GGApiManager request_InvitationRecordsWithParames:dic] map:^id(NSDictionary *value) {
                @strongify(self);
                self.pageNo = [value[@"pageNo"] integerValue];
                self.totalCount = value[@"totalRecord"];
                NSArray *resultArray = [NSArray modelArrayWithClass:[GGInvite class] json:value[@"result"]];
                [self.dataSource addObjectsFromArray:resultArray];
                self.canLoadMore = self.pageNo <= [value[@"totalPage"] integerValue];
                return [RACSignal empty];
            }];
        }];
    }
    return _loadData;
}

@end
