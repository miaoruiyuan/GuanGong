//
//  GGAttestationViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/30.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGAttestationViewModel.h"


@interface GGAttestationViewModel ()


@property(nonatomic,strong)NSArray *configArray;


@end

@implementation GGAttestationViewModel

- (GGAttestation *)attestation{
    if (!_attestation) {
        _attestation = [[GGAttestation alloc] init];
    }
    return _attestation;
}

- (void)initialize{
    
    self.configArray = [NSArray configArrayWithResource:@"Attestation"];
    [self createTableDataSource];
    
    _enableSubmit = [RACSignal combineLatest:@[RACObserve(self.attestation, realName),
                                               RACObserve(self.attestation, identification),
                                               RACObserve(self.attestation, location),
                                               RACObserve(self.attestation, identificationOppoUrl),
                                               RACObserve(self.attestation, identificationPosUrl),
                                               ] reduce:^id(NSString *name,NSString *identif,NSString *picPos,NSString *picOppo,NSString *location){
                                                   return @(name && name.length > 1 && identif.length >1 && picPos && picOppo && location);
                                               }];
}

- (void)setAttestationDefaultData
{
    GGUser *user = [GGLogin shareUser].user;
    if (user.auditingType == AuditingTypeInvaild) {
        self.attestation.cityId = [user.cityId numberValue];
        self.attestation.provinceId = [user.provinceId numberValue];
        self.attestation.location = user.location;
        self.attestation.identification = user.identification;
        self.attestation.realName = user.realName;
        self.attestation.identificationPosUrl = user.identificationPosUrl;
        self.attestation.identificationOppoUrl = user.identificationOppoUrl;
    }
    [self createTableDataSource];
}

- (void)createTableDataSource
{
    NSMutableArray *totalArray = [NSMutableArray array];
    
    @autoreleasepool {
        for (int i = 0; i < self.configArray.count; i ++) {
            NSMutableArray *sectionArray = [NSMutableArray array];
            for (int j = 0; j < [self.configArray[i] count]; j ++ ) {
                NSDictionary *configDic = self.configArray[i][j];
                GGFormItem *item = [self itemWithConfigDic:configDic mode:self.attestation];
                [sectionArray addObject:item];
            }
            [totalArray addObject:sectionArray];
        }
    }
    
    self.dataSource = totalArray;
}

-(NSMutableArray *)converWithModel:(GGAttestation *)model{
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


-(id)itemWithConfigDic:(NSDictionary *)dic mode:(id)model{
    GGFormItem *item = [GGFormItem modelWithDictionary:dic];
    item.obj = model ? [model valueForKey:item.propertyName] : nil;
    
    if (item.pageType == GGPageTypeInput) {
        item.pageContent = [GGPersonalInput modelWithDictionary:dic[@"pageContent"]];
    }
    
    return item;
}

- (RACCommand *)attestationCommand{
    
    @weakify(self);
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSMutableDictionary *parmas = [@{}mutableCopy];
        [parmas addEntriesFromDictionary:[self.attestation modelToJSONObject]];
        
        NSArray *identificationOppoUrls = [parmas[@"identificationOppoUrl"] componentsSeparatedByString:@"?"];
        NSArray *identificationPosUrls = [parmas[@"identificationPosUrl"] componentsSeparatedByString:@"?"];

        if (identificationOppoUrls.count > 0) {
            [parmas setObject:identificationOppoUrls[0] forKey:@"identificationOppoUrl"];
        }
        
        if (identificationPosUrls.count > 0) {
            [parmas setObject:identificationPosUrls[0] forKey:@"identificationPosUrl"];
        }
        
        return [[GGApiManager request_CompleteInfomationWithParames:parmas] map:^id(NSDictionary *value) {
            [[GGLogin shareUser] updateUser:[GGUser modelWithDictionary:value]];
            return [RACSignal empty];
        }];
    }];
}

- (RACCommand *)reloadData
{
    @weakify(self);
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            GGFormItem *item = input;
            if (item) {
                if (item.pageType == GGPageTypeCityList) {
                    NSDictionary *cityInfoDic = item.obj;
                    if ([cityInfoDic isKindOfClass:[NSDictionary class]]) {
                        item.obj = cityInfoDic[@"location"];
                        self.attestation.cityId = cityInfoDic[@"cityId"];
                        self.attestation.provinceId = cityInfoDic[@"provinceId"];
                    }
                }
                [self.attestation setValue:item.obj forKey:item.propertyName];
            }
            self.dataSource = [self converWithModel:self.attestation];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
}

@end


@implementation GGAttestation

@end

