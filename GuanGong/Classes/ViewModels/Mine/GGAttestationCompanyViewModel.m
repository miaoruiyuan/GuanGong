//
//  GGAttestationCompanyViewModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/6.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGAttestationCompanyViewModel.h"

@interface GGAttestationCompanyViewModel()
{
    
}

@property(nonatomic,strong)NSArray *configArray;

@end

@implementation GGAttestationCompanyViewModel

@synthesize attestationCompany = _attestationCompany;

- (void)initialize{
    _isSocialCreditCode = YES;
    self.configArray = [NSArray configArrayWithResource:@"AttestationCompany"];
    [self createTableDataSource];
    _enableSubmit = [RACSignal combineLatest:@[RACObserve(self.attestationCompany, companyName),
                                               RACObserve(self.attestationCompany, legalPersonName),
                                               RACObserve(self.attestationCompany, legalPersonPhone),
                                               RACObserve(self.attestationCompany, businessLicenceCode),
                                               RACObserve(self.attestationCompany, businessLicencePic),
                                               RACObserve(self.attestationCompany, socialCreditCode),
                                               RACObserve(self.attestationCompany, identificationOppoUrl),
                                               RACObserve(self.attestationCompany, identificationPosUrl),
                                               ] reduce:^id(id x){
                                                   return @([self checkRequestData]);
                                               }];
}

- (BOOL)checkRequestData
{
    if (self.attestationCompany.businessLicenceCode.length > 0) {
        if (self.attestationCompany.companyName &&
            self.attestationCompany.legalPersonName &&
            self.attestationCompany.legalPersonPhone &&
            self.attestationCompany.businessLicencePic &&
            self.attestationCompany.identificationOppoUrl &&
            self.attestationCompany.identificationPosUrl) {
            return YES;
        }
    }else if (self.attestationCompany.socialCreditCode.length > 0){
        if (self.attestationCompany.companyName &&
            self.attestationCompany.legalPersonName &&
            self.attestationCompany.legalPersonPhone &&
            self.attestationCompany.businessLicencePic &&
            self.attestationCompany.identificationOppoUrl &&
            self.attestationCompany.identificationPosUrl) {
            return YES;
        }
    }
    return NO;
}

- (GGAttestationCompany *)attestationCompany
{
    if (!_attestationCompany) {
        _attestationCompany = [[GGAttestationCompany alloc] init];
    }
    return _attestationCompany;
}

- (void)setAttestationDefaultData
{
    GGCompanyModel *company = [GGLogin shareUser].company;
    if (company.auditStatus == CompanyAuditingTypeInvaild) {
        self.attestationCompany.companyName = company.companyName;
        self.attestationCompany.legalPersonName = company.legalPersonName;
        self.attestationCompany.legalPersonPhone = company.legalPersonPhone;
        self.attestationCompany.socialCreditCode = company.socialCreditCode;
        self.attestationCompany.businessLicenceCode = company.businessLicenceCode;
        self.attestationCompany.businessLicencePic = company.businessLicencePic;
        self.attestationCompany.identificationPosUrl = company.identificationPosUrl;
        self.attestationCompany.identificationOppoUrl = company.identificationOppoUrl;
    }
    
    if (self.attestationCompany.businessLicenceCode.length == 15) {
        self.isSocialCreditCode = NO;
    }else if (self.attestationCompany.socialCreditCode.length == 18){
        self.isSocialCreditCode = YES;
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
                GGFormItem *item = [self itemWithConfigDic:configDic mode:self.attestationCompany];
                [sectionArray addObject:item];
            }
            [totalArray addObject:sectionArray];
        }
    }
    self.dataSource = totalArray;
}

-(NSMutableArray *)converWithModel:(GGAttestationCompany *)model{
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
    
    if ([item.propertyName isEqualToString:@"businessLicenceCode"] || [item.propertyName isEqualToString:@"socialCreditCode"] ) {
        if (self.isSocialCreditCode) {
            item.propertyName = @"socialCreditCode";
            item.title = @"统一社会信用代码";
        }else{
            item.propertyName = @"businessLicenceCode";
            item.title = @"营业执照号";
        }
    }
    item.obj = model ? [model valueForKey:item.propertyName] : nil;

    if (item.pageType == GGPageTypeInput) {
        item.pageContent = [GGPersonalInput modelWithDictionary:dic[@"pageContent"]];
    }
    
    return item;
}

- (RACCommand *)attestationCommand{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSMutableDictionary *parmas = [@{}mutableCopy];
        [parmas addEntriesFromDictionary:[self.attestationCompany modelToJSONObject]];
        
        NSArray *identificationOppoUrls = [parmas[@"identificationOppoUrl"] componentsSeparatedByString:@"?"];
        NSArray *identificationPosUrls = [parmas[@"identificationPosUrl"] componentsSeparatedByString:@"?"];
        NSArray *businessLicencePics = [parmas[@"businessLicencePic"] componentsSeparatedByString:@"?"];
        
        if (identificationOppoUrls.count > 0) {
            [parmas setObject:identificationOppoUrls[0] forKey:@"identificationOppoUrl"];
        }
        
        if (identificationPosUrls.count > 0) {
            [parmas setObject:identificationPosUrls[0] forKey:@"identificationPosUrl"];
        }
        
        if (businessLicencePics.count > 0) {
            [parmas setObject:businessLicencePics[0] forKey:@"businessLicencePic"];
        }
        if (self.isSocialCreditCode) {
            self.attestationCompany.businessLicenceCode = @"";
        }else{
            self.attestationCompany.socialCreditCode = @"";
        }
        
        return [[GGApiManager request_ApplyCompanyWithParames:parmas] map:^id(NSDictionary *value) {
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
                [self.attestationCompany setValue:item.obj forKey:item.propertyName];
            }
            self.dataSource = [self converWithModel:self.attestationCompany];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
}

@end
