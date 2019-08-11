//
//  GGSettingViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGSettingViewModel.h"

@interface GGSettingViewModel ()

@property(nonatomic,strong)NSArray *configArray;

@end

@implementation GGSettingViewModel

- (void)initialize{
    self.configArray = [NSArray configArrayWithResource:@"SystemSetting"];
    self.dataSource = [self converWithModel];
}

-(NSMutableArray *)converWithModel{
    
    NSMutableArray *totalArray = [NSMutableArray array];
    @autoreleasepool {
        for (int i = 0; i < [self.configArray count]; i ++) {
            NSMutableArray *sectionArray = [NSMutableArray array];
            for (int j = 0; j < [self.configArray[i] count]; j ++ ) {
                NSDictionary *configDic = self.configArray[i][j];
                GGFormItem *item = [GGFormItem modelWithDictionary:configDic];
                [sectionArray addObject:item];
            }
            [totalArray addObject:sectionArray];
        }
    }
    
    return totalArray;
}


- (RACCommand *)logoutCommand{
    
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[[GGApiManager request_userLogoutWithParameter:input] map:^id(NSDictionary *value) {
            return [RACSignal empty];
        }]catch:^RACSignal *(NSError *error) {
            return [RACSignal error:error];
        }];
    }];
}


@end
