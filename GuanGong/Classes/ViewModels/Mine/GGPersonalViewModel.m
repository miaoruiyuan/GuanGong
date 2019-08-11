//
//  GGPersonalViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPersonalViewModel.h"

@interface GGPersonalViewModel ()

@property(nonatomic,strong)NSArray *configArray;


@end

@implementation GGPersonalViewModel

- (void)initialize{
    
    self.configArray = [NSArray configArrayWithResource:@"PersonalMain"];
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


@end
