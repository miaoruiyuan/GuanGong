//
//  GGSetPasswordViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGSetPasswordViewModel.h"

@implementation GGSetPasswordViewModel

- (void)initialize
{
    _enabelSignal = [RACSignal combineLatest:@[RACObserve(self, iCode),
                                               RACObserve(self, password1),
                                               RACObserve(self, password2)]
                                          reduce:^id(NSString *number,NSString *p1 ,NSString *p2){
                                              return @(number.length == 6 && p1.length == 6 && p2.length == 6 && [p1 isEqualToString:p2]);
                                          }];
}

- (RACCommand *)setPayPasswordCommand
{
    @weakify(self);
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSString *input) {
        @strongify(self);
        return [[GGApiManager request_ResetPayPassword_WithPayPassword:self.password2 andIdentifyCode:self.iCode] map:^id(id value) {
            return [RACSignal empty];
        }];
    }];
}

@end
