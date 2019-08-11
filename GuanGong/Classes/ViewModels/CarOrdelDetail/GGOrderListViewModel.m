//
//  GGOrderListModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOrderListViewModel.h"

@interface GGOrderListViewModel ()

@property(nonatomic,copy)NSString *dynamicCode;

@end

@implementation GGOrderListViewModel

- (void)initialize{

    @weakify(self);
    self.loadData = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSNumber *input) {
        @strongify(self);
        NSDictionary *dic;
        if (self.transStatus && self.transStatus.length > 0) {
            dic = @{@"goodsTypeId":@(self.type),
                    @"isBuyer":input,
                    @"page":self.willLoadMore ? [NSNumber numberWithInteger:self.pageIndex + 1] : @1,
                    @"pageSize":@"20",
                    @"transStatus":self.transStatus};
        }else{
            dic = @{@"goodsTypeId":@(self.type),
                    @"isBuyer":input,
                    @"page":self.willLoadMore ? [NSNumber numberWithInteger:self.pageIndex + 1] : @1,
                    @"pageSize":@"20"};
        }
        
        return [[GGApiManager request_PaymentOrderListWithParames:dic] map:^id(NSDictionary *value) {
            @strongify(self);
            NSArray *models = [NSArray modelArrayWithClass:[GGOrderList class] json:value[@"result"]];
            
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
            
            self.pageIndex = [value[@"pageNo"] integerValue];
            
            return [RACSignal empty];
        }];
    }];
}

#pragma mark - 买家确认收货
- (RACCommand *)confirmGoods{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *password) {
        return [[[GGApiManager request_GetDynamicCode]map:^id(NSString *value) {
            @strongify(self);
            self.dynamicCode = value;
            return [RACSignal empty];
        }]then:^RACSignal *{

            @strongify(self);
            NSArray *array = @[self.orderNo,
                               [GGLogin shareUser].token,
                               self.dynamicCode,
                               password];
            
            NSString *payPassword = [[GGHttpSessionManager sharedClient].rsaSecurity
                                     rsaEncryptString:[array componentsJoinedByString:@""]];
                        
            return [[GGApiManager request_BuyerConfirmGoodsWithParames:@{@"orderNo":self.orderNo,@"payPassword":payPassword}] map:^id(id value) {
                return [RACSignal empty];
            }];
        }];
    }];
}

@end
