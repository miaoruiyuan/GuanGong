//
//  GGCapitalClearViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCapitalClearViewModel.h"
#import "GGImageItem.h"

@implementation GGCapitalClearViewModel

- (NSArray *)photos{
    if (!_photos) {
        _photos = [[NSArray alloc] init];
    }
    return _photos;
}

- (void)initialize{
    
    @weakify(self);
    _enableSubmitSignal = [RACSignal combineLatest:@[RACObserve(self, amount),
                                                     RACObserve(self, accountNo),
                                                     RACObserve(self, bankName)] reduce:^id(NSString *amount,NSString *bankNo,NSString *bankName){
        
                                                         return @(amount.length > 0 && bankNo.length > 0 && bankName.length > 0);
    }];
    
    
    
    
    //提交申请
    _submitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSDictionary *dic = @{@"accountNo":self.accountNo,
                              @"amount":self.amount,
                              @"bankName":self.bankName
                              };
        
        NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        for (int i = 0 ; i < self.photos.count; i ++ ) {
            GGImageItem *image = self.photos[i];
            [mDic setObject:image.photoUrl forKey:[NSString stringWithFormat:@"pic%d",i + 1]];
        }
        

        return [[GGApiManager request_SubmitCapitalClearApplyWithParames:mDic] map:^id(NSDictionary *value) {
            return [RACSignal empty];
        }];
    }];
    
    
    
    //申请记录列表
    self.loadData = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);

        return [[GGApiManager request_CapitalClearApplyListWithPage:self.willLoadMore ? [NSNumber numberWithInteger:self.pageIndex + 1] : @1] map:^id(id value) {
            @strongify(self);

            NSArray *models = [NSArray modelArrayWithClass:[GGCapitalClearList class] json:value[@"result"]];
            
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
    
    
    //记录详情
    _detailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        return [[GGApiManager request_CapitalClearDetailWithApplyId:input] map:^id(NSDictionary *value) {
            @strongify(self);
            self.clearDetail  = [GGCapitalClearList modelWithDictionary:value];
            return [RACSignal empty];
            
        }];
    }];
}

@end
