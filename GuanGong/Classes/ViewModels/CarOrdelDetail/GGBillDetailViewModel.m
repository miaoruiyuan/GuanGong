//
//  GGBillDetailViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBillDetailViewModel.h"

@implementation GGBillDetailViewModel

- (void)initialize{

    @weakify(self);
    _detailDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return  [[GGApiManager request_BillDetail_WithPayId:input] map:^id(NSDictionary *value) {
            @strongify(self);
            self.billInfo = [GGBillInfo modelWithDictionary:value];
            return [RACSignal empty];
        }];
    }];
}

@end
