//
//  GGMyFriendsViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/5.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMyFriendsViewModel.h"


@implementation GGMyFriendsViewModel

- (void)initialize{
    
    @weakify(self);
    self.loadDBdata = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            NSDictionary *value =  [[[GGDataBaseManager shareDB] getMyFriendsLists] mutableCopy];
            self.dataSource = [self getFriendsArrayWithValue:value];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    
    self.loadData = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSNumber *input) {
        
        return [[GGApiManager request_MyFriensList] map:^id(NSDictionary *value) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *contactList = value[@"contactList"];
                if (!contactList) {
                    contactList = value;
                }
                @strongify(self);
                self.dataSource = [self getFriendsArrayWithValue:contactList];
                if (contactList) {
                    [[GGDataBaseManager shareDB] putMyFriendsListWithData:contactList];
                }
            }
            return [RACSignal empty];
        }];
    }];

    
    [[self.loadData.executing skip:1]subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.isLoading = x.boolValue;
    }];

    
    _friendNewCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSNumber *input) {
        return [[GGApiManager request_MyNewFriensList]map:^id(NSDictionary *value) {
            NSDictionary *contactDic = value[@"contactList"];
            if (!contactDic) {
                contactDic = value;
            }
            NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:value.count];
            [resultArray addObject:@[@"添加手机联系人"]];
            [resultArray addObject:[[NSMutableArray alloc] init]];
            for (NSArray *array in [contactDic allValuesSortedByKeys]) {
                NSArray *models = [NSArray modelArrayWithClass:[GGFriendsList class] json:array];
                [(NSMutableArray *)resultArray[1] addObjectsFromArray:models];
            }
            
            @strongify(self);
            self.dataSource = resultArray;
            return [RACSignal empty];
        }];
    }];
    
    
    [[self.friendNewCommand.executing skip:1]subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.isLoading = !x.boolValue;
    }];
    
    //申请代付
    _applyPayCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        @strongify(self);
        NSDictionary *dic = @{@"orderNo":self.orderNo ? self.orderNo : @"",
                              @"goodsStatusId":self.goodsStatusId,
                              @"salerId":self.salerId,
                              @"remark":self.remark ? self.remark : @"",
                              @"payerId":input,
                              @"amount":self.applyAmount};

        return [[GGApiManager request_ApplyPaymentWithParames:dic]map:^id(NSDictionary *value) {
            return [RACSignal empty];
        }];
    }];
}


- (NSMutableArray *)getFriendsArrayWithValue:(NSDictionary *)value{
    NSMutableArray *titlesArr = [[value allKeysSorted] mutableCopy];
    if ([titlesArr containsObject:@"#"]) {
        [titlesArr removeObject:@"#"];
        [titlesArr addObject:@"#"];
    }
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:value.count];
    for (NSString *key in titlesArr) {
        NSArray *models = [NSArray modelArrayWithClass:[GGFriendsList class] json:value[key]];
        [resultArray addObject:models];
    }
    
    [titlesArr insertObject:UITableViewIndexSearch atIndex:0];

    self.indexTitles = titlesArr;

    return resultArray;
}



@end
