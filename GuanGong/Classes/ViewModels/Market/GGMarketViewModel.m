//
//  GGMarketViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMarketViewModel.h"
#import "GGMarketItem.h"
#import "GGUserInfoViewModel.h"

@interface GGMarketViewModel ()

@property(nonatomic,strong)NSArray *configArray;

@end

@implementation GGMarketViewModel

- (void)initialize{
 
    self.configArray = [NSArray configArrayWithResource:@"MarketMain"];
    
    NSMutableArray *totalArray = [NSMutableArray arrayWithCapacity:self.configArray.count];
    @autoreleasepool {
        for (int i = 0; i < self.configArray.count; i ++) {
            NSMutableArray *sectionArray = [NSMutableArray array];
            for (int j = 0; j < [self.configArray[i] count]; j ++ ) {
                NSDictionary *configDic = self.configArray[i][j];
                GGMarketItem *item = [GGMarketItem modelWithDictionary:configDic];
                [sectionArray addObject:item];
            }
            [totalArray addObject:sectionArray];
        }
    }
    
    self.dataSource = totalArray;
    
    NSString *version = [[UIApplication sharedApplication] appVersion];
    if ([version isEqualToString:@"1.4.3"] && [self canShowVBankNewIcon]) {
        [(GGMarketItem *)[self.dataSource[0] lastObject] setShowNew:YES];
    }
    
    GGUserInfoViewModel *userVM = [[GGUserInfoViewModel alloc] init];
    [[userVM.getBaseUserInfoCommand executing] subscribeNext:^(id x) {
        if ([GGLogin shareUser].isLogin && [GGLogin shareUser].user.auditingType == AuditingTypePass) {
            [[userVM getAcountInfoCommand] execute:nil];
        }
        DLog(@"启动更新用户信息")
    }];
}

- (BOOL)canShowVBankNewIcon
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault objectForKey:GGVBankShowNewIconKey]) {
        return YES;
    }
    return NO;
}

- (void)setVBankDidClicked
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:YES forKey:GGVBankShowNewIconKey];
    [userDefault synchronize];
}

@end
