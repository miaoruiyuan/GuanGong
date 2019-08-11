//
//  GGBindCardViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/14.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBindCardViewModel.h"
#import "GGBank.h"

@interface GGBindCardViewModel ()

@property(nonatomic,strong)NSArray *configArray;

@end

@implementation GGBindCardViewModel

- (GGBank *)bank{
    if (!_bank) {
        _bank = [[GGBank alloc]init];
    }
    return _bank;
}

- (GGBankAddress *)bankAddress
{
    if (!_bankAddress) {
        _bankAddress = [[GGBankAddress alloc] init];
    }
    return _bankAddress;
}

- (void)initialize
{
    self.configArray = [NSArray configArrayWithResource:@"BindingCard"];
    
    self.userName = [GGLogin shareUser].user.realName;
    self.dataSource = [self converWithModel:self];
    
    _enableBindSignal = [RACSignal combineLatest:@[RACObserve(self,mobilePhone),
                                                  RACObserve(self,acctId),
                                                  RACObserve(self,bank.bankName),
                                                  RACObserve(self,messageCode),
                                                  RACObserve(self,bankAddress.bankName)]
                                         reduce:^id(NSString *mobile,NSString *accid,NSString *bName,
                                                    NSString *messageCode,NSString *bandAddressBName){
                                             return @(mobile.length == 11 && accid.length > 12 &&
                                             bName.length > 0 && messageCode.length > 4 &&
                                             bandAddressBName.length > 0);
                                         }];
    
    _enableSendSMSSignal = [RACSignal combineLatest:@[RACObserve(self,mobilePhone),
                                                      RACObserve(self,acctId),
                                                      RACObserve(self,bank.bankName),
                                                      RACObserve(self,bankAddress.bankName)] reduce:^id(NSString *mobile,NSString *accid,NSString *bName,NSString *bandAddressBName){
                                                          return @(mobile.length == 11 && accid.length > 12 &&
                                                          bName.length > 0 &&
                                                          bandAddressBName.length > 0);
    }];
}

- (NSMutableArray *)converWithModel:(GGBindCardViewModel *)model
{
    NSMutableArray *totalArray = [NSMutableArray array];
    @autoreleasepool {
        for (int i = 0; i < [self.configArray count]; i ++) {
            NSMutableArray *sectionArray = [NSMutableArray array];
            for (int j = 0; j < [self.configArray[i] count]; j ++ ) {
                NSDictionary *configDic = self.configArray[i][j];
                GGFormItem *item = [self itemWithConfigDic:configDic mode:self];
                [sectionArray addObject:item];
            }
            [totalArray addObject:sectionArray];
        }
    }
    return totalArray;
}

-(id)itemWithConfigDic:(NSDictionary *)dic mode:(id)model
{
    GGFormItem *item = [GGFormItem modelWithDictionary:dic];
    item.obj = model ? [model valueForKey:item.propertyName] : nil;
    
    if (item.pageType == GGPageTypeInput) {
        item.pageContent = [GGPersonalInput modelWithDictionary:dic[@"pageContent"]];
    }
    return item;
}


- (RACCommand *)reloadData
{
    @weakify(self);
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
     
            @strongify(self);
            GGFormItem *item = input;
            if (item) {
                [self setValue:item.obj forKey:item.propertyName];
            }
            self.dataSource  = [self converWithModel:self];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
}

- (RACCommand *)sendIdentifyCommand
{
    @weakify(self);
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if ([self.bank.bankCode isEqualToNumber:@307584007998]) {
            self.bankType = 1;
        }else{
            self.bankType = 2;
        }
        
        NSDictionary *dic = @{@"acctId":self.acctId,
                              @"bankType":@(self.bankType),
                              @"mobilePhone":self.mobilePhone,
                              @"sBankCode":self.bank.bankCode,
                              @"bankTitle":self.bank.bankName,
                              @"bankName":self.bankAddress.bankName,
                              @"bankCode":self.bankAddress.bankNo
                              };
        return [[GGApiManager request_getMessageCodeBeforeBindBankCardWithParames:dic] map:^id(id value) {
            return [RACSignal empty];
        }];
    }];
}

- (RACCommand *)confirmCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSDictionary *dic = @{@"acctId":self.acctId,
                              @"messageCode":self.messageCode};
        return [[GGApiManager request_BindBankCardCaptchaVerifyParames:dic] map:^id(id value) {
            return [RACSignal empty];
        }];
    }];
}

@end
