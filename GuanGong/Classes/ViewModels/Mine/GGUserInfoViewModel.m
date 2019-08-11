//
//  GGUserInfoViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGUserInfoViewModel.h"
#import "GGBankCard.h"

@interface GGUserInfoViewModel ()

@property(nonatomic,strong)NSArray *configArray;

@end

@implementation GGUserInfoViewModel

- (GGUser *)user{
    if (!_user) {
        _user = [[GGUser alloc]init];
    }
    return _user;
}

- (void)initialize{
    self.configArray = [NSArray configArrayWithResource:@"MineInformation"];
    NSMutableArray *tableArray = [self converWithModel:[GGLogin shareUser].user];
    if ([GGLogin shareUser].user.auditingType != AuditingTypePass) {
        [tableArray[1] removeLastObject];
    }
    self.dataSource = tableArray;
    [self.getBaseUserInfoCommand execute:0];
}

-(NSMutableArray *)converWithModel:(GGUser *)model{
    NSMutableArray *totalArray = [NSMutableArray array];
    @autoreleasepool {
        for (int i = 0; i < [self.configArray count]; i ++) {
            NSMutableArray *sectionArray = [NSMutableArray array];
            for (int j = 0; j < [self.configArray[i] count]; j ++ ) {
                NSDictionary *configDic = self.configArray[i][j];
                GGFormItem *item = [self itemWithConfigDic:configDic mode:model];
                [sectionArray addObject:item];
            }
            [totalArray addObject:sectionArray];
        }
    }
    return totalArray;
}

- (id)itemWithConfigDic:(NSDictionary *)dic mode:(id)model{
    GGFormItem *item = [GGFormItem modelWithDictionary:dic];
    
    if (item.propertyName) {
        item.obj = model ? [model valueForKey:item.propertyName] : nil;
    }

    if (item.pageType == GGPageTypeInput) {
        item.pageContent = [GGPersonalInput modelWithDictionary:dic[@"pageContent"]];
    }
    return item;
}

- (RACCommand *)getBaseUserInfoCommand{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[GGApiManager request_getUserBaseInfo] map:^id(NSDictionary *value) {
            @strongify(self);
            [self updateUserInfo:value];
            return [RACSignal empty];
        }];
    }];
}

- (RACCommand *)getAcountInfoCommand{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[GGApiManager request_AccountInfo] map:^id(NSDictionary *value) {
            GGWallet *wallet = [GGWallet modelWithDictionary:value];
            [[GGLogin shareUser] updateAmount:wallet];
            return [RACSignal empty];
        }];
    }];
}

- (void)updateUserInfo:(NSDictionary *)value
{
    self.user = [GGUser modelWithDictionary:value[@"user"]];
    
    if (self.user.province && self.user.city) {
        if ([self.user.province isEqualToString:self.user.city]) {
            self.user.location = [NSString stringWithFormat:@"%@",self.user.province];
        }else{
            self.user.location = [NSString stringWithFormat:@"%@ %@",self.user.province,self.user.city];
        }
    }
    
    NSArray *cards = [value valueForKey:@"cards"];
    if ([cards isKindOfClass:[NSArray class]]) {
        NSMutableArray *cardList =  [NSMutableArray arrayWithCapacity:cards.count];
        NSArray *modelArray = [NSArray modelArrayWithClass:[GGBankCard class] json:cards];
        for (GGBankCard *bankCard in modelArray) {
            if (bankCard.unBinding == 0) {
                [cardList addObject:bankCard];
            }
        }
        [GGLogin shareUser].cards = cardList;
    }
    if ([value valueForKey:@"company"]) {
        GGCompanyModel *company = [GGCompanyModel modelWithJSON:[value valueForKey:@"company"]];
        self.user.companyAuditingType = company.auditStatus;
        [[GGLogin shareUser] updateCompany:company];
    }
    [[GGLogin shareUser] updateUser:self.user];
    
    NSMutableArray *tableArray = [[self converWithModel:self.user] mutableCopy];
    if (self.user.auditingType != AuditingTypePass) {
        [tableArray[1] removeLastObject];
    }
    self.dataSource = tableArray;
}


- (RACCommand *)editCommand{
    @weakify(self);
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(GGFormItem *formItem) {
        GGFormItem *item = formItem;
        NSMutableDictionary *parames = [@{}mutableCopy];
        if ([item.obj isKindOfClass:[NSDictionary class]]) {
            [parames addEntriesFromDictionary:item.obj];
        }else if ([item.obj isKindOfClass:[NSString class]]){
            [parames setValue:item.obj forKey:item.propertyName];
        }
        
        return [[GGApiManager request_EditUserInfoWithParames:parames] map:^id(NSDictionary *value) {
            @strongify(self);
            self.user = [GGUser modelWithDictionary:value];
            [[GGLogin shareUser] updateUser:self.user];
            NSMutableArray *tableArray = [[self converWithModel:self.user] mutableCopy];
            if (self.user.auditingType != AuditingTypePass) {
                [tableArray[1] removeLastObject];
            }
            self.dataSource = tableArray;
            return [RACSignal empty];
        }];
    }];
}

@end
