//
//  GGBankRechargeViewModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/7/20.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGBankRechargeViewModel.h"
#import "GGApiManager+Recharge.h"
#import "GGBankRechargeRateModel.h"


@interface GGBankRechargeViewModel()
{

}

@property (nonatomic,strong)NSString *dynamicCode;

@end

@implementation GGBankRechargeViewModel

@synthesize calculationFeeCommand = _calculationFeeCommand;
@synthesize sendPaySMSCommand = _sendPaySMSCommand;
@synthesize paySMSConfirmCommand = _paySMSConfirmCommand;

- (void)initialize
{
    @weakify(self);
    
    _getChargeRateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[GGApiManager request_GetChargeRateWithParameter:@{}] map:^id(id value) {
            @strongify(self);
            self.rateModel = [GGBankRechargeRateModel modelWithDictionary:value];
            return [RACSignal empty];
        }];
    }];
    
    _getOpenedCardListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[GGApiManager request_GetOpenCardListWithParameter:@{}] map:^id(id value) {
            @strongify(self);
            NSArray *dataArray = [NSArray modelArrayWithClass:[GGBankRechargeListModel class] json:value];
            self.cardArray = [[NSMutableArray alloc] initWithArray:dataArray];
            for (GGBankRechargeListModel *model in self.cardArray) {
                if (model.isDefault) {
                    self.defaultBankModel = model;
                }
            }
            
            if (!self.defaultBankModel && self.cardArray.count > 0) {
                self.defaultBankModel = [self.cardArray objectAtIndex:0];
            }
            
            return [RACSignal empty];
        }];
    }];
    
    _openCardApplyCommand =  [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *dic) {
        return [[GGApiManager request_OpenBankCardApplyWithParameter:dic] map:^id(id value) {
            @strongify(self);
            self.payOpenModel = [GGUnionPayOpenModel modelWithDictionary:value];
            return [RACSignal empty];
        }];
    }];
}


#pragma mark -  获取转账利息
- (RACCommand *)calculationFeeCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id value) {
        @strongify(self);
        NSString *feeType = @"";
        if ([self.defaultBankModel.cardType isEqualToString:@"01"]) {
            feeType = @"2";
        }else if ([self.defaultBankModel.cardType isEqualToString:@"02"]){
            feeType = @"3";
        }
        
        NSDictionary *dic = @{@"amount":self.rechargeAmount,
                              @"feeType":feeType
                              };
        return [GGApiManager request_CalculationFeeWithParameter:dic];
    }];
}

- (RACCommand *)sendPaySMSCommand
{
    @weakify(self);
    
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *password) {
        @strongify(self);
        self.password = password;
        return [[[GGApiManager request_GetDynamicCode]map:^id(NSString *value) {
            @strongify(self);
            self.dynamicCode = value;
            return [RACSignal empty];
        }] then:^RACSignal *{
            @strongify(self);
            NSArray *array = @[[GGLogin shareUser].token,
                               self.dynamicCode,
                               self.defaultBankModel.openId,
                               self.rechargeAmount,
                               password];
            
            NSString *encodePayPassword = [[GGHttpSessionManager sharedClient].rsaSecurity
                                     rsaEncryptString:[array componentsJoinedByString:@""]];
            NSDictionary *dic = @{@"amount":self.rechargeAmount,
                                  @"payPassword":encodePayPassword,
                                  @"openId":self.defaultBankModel.openId
                                  };
            return [[GGApiManager request_SendBankPaySMSWithParameter:dic] map:^id(id value) {
                self.payOrderNO = [value objectForKey:@"orderNo"];
                return [RACSignal empty];
            }];
        }];
    }];
}

- (RACCommand *)paySMSConfirmCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *verfyCode) {
        @strongify(self);
        NSDictionary *dic = @{@"verfyCode":verfyCode,
                              @"orderNo":self.payOrderNO
                              };
        return [GGApiManager request_BankPayConfirmWithParameter:dic];
    }];
}


@end
