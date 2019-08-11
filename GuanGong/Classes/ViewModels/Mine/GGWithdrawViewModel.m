//
//  GGWithdrawViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/14.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGWithdrawViewModel.h"

@implementation GGWithdrawViewModel

- (NSMutableArray *)cards{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (void)initialize{
    
    @weakify(self);
    _enableSignal = [RACSignal combineLatest:@[RACObserve(self, tranAmount)] reduce:^id(NSString *amount){
        @strongify(self);
        return @(self.bankCard && amount.floatValue > 0 && amount.floatValue <= [GGLogin shareUser].wallet.totalTranOutAmount.floatValue);
    }];
}


#pragma mark - 获取订单号
- (RACCommand *)getOrderCommand{
    
    @weakify(self);
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSString *password) {
        
        return [[[GGApiManager request_GetDynamicCode]map:^id(NSString *value) {
            @strongify(self);
            self.dynamicCode = value;
            return [RACSignal empty];
        }]then:^RACSignal *{
            
            @strongify(self);
            self.acctId = self.bankCard.idCode;
            
            NSString *payPassword = [@[[[GGLogin shareUser] token],self.dynamicCode,self.acctId,self.tranAmount,password] componentsJoinedByString:@""];
            
            NSDictionary *parmas = @{@"tranAmount":self.tranAmount,
                                     @"acctId":self.acctId,
                                     @"payPassword":[[GGHttpSessionManager sharedClient].rsaSecurity rsaEncryptString:payPassword]};
            
            return [[[GGApiManager request_BeforeDrawCashGetOrderNoWithParameter:parmas] map:^id(NSDictionary *value) {
                @strongify(self);
                self.orderNo = [value objectForKey:@"subOrderNo"];
                self.phoneLast4Code = [value objectForKey:@"revMobilePhone"];
                return [RACSignal empty];
            }]catch:^RACSignal *(NSError *error) {
                return [RACSignal error:error];
            }];
        }];
    }];
}

#pragma mark - 确认转账
- (RACCommand *)doneCommand{
    @weakify(self);
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSDictionary *dic = @{@"orderNo":self.orderNo,
                              @"messageCode":self.messageCode};
        return [[GGApiManager request_WithDrawCashWithParames:dic] map:^id(id value) {
            return [RACSignal empty];
        }];
    }];
}

#pragma mark - 银行卡列表
- (RACCommand *)bankCardsCommand{
    if (!_bankCardsCommand) {
        @weakify(self);
        _bankCardsCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [[GGApiManager request_MineBankLists] map:^id(NSDictionary *value) {
                @strongify(self);
                NSArray *modelArray = [NSArray modelArrayWithClass:[GGBankCard class] json:value];
                NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:modelArray.count];
                
                for (GGBankCard *bankCard in modelArray) {
                    if (bankCard.unBinding == 0) {
                        [dataArray addObject:bankCard];
                    }
                }

                self.cards = dataArray;
                
                [GGLogin shareUser].cards = dataArray;
                
                self.bankCard = [dataArray firstObject];
                
                return [RACSignal empty];
            }];
        }];
    }
    
    return _bankCardsCommand;
}

#pragma mark - 解绑银行卡

- (RACCommand *)unBindingCommand{
    
    @weakify(self);
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSString *input) {
        @strongify(self);
        NSString *password = [NSString stringWithFormat:@"%@%@",self.acctId,input];
        NSDictionary *dic = @{@"acctId":self.acctId,
                              @"payPassword":[[GGHttpSessionManager sharedClient].rsaSecurity rsaEncryptString:password]};
        return [[GGApiManager request_unBingingBankCardWithParames:dic] map:^id(id value) {
            return [RACSignal empty];
        }];
    }];
}

#pragma mark -  获取转账利息
- (RACCommand *)calculationFeeCommand
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *amount) {
        NSDictionary *dic = @{@"amount":amount,
                              @"feeType":@"1"
                              };
        return [GGApiManager request_CalculationFeeWithParameter:dic];
    }];
}

@end
