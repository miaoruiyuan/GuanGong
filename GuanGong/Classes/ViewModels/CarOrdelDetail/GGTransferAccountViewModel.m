//
//  GGTransferAccountViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/12.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTransferAccountViewModel.h"

@interface GGTransferAccountViewModel ()
{
    
}

@property (nonatomic,strong,readwrite)RACSignal *enabelSureSignal;

@end

@implementation GGTransferAccountViewModel

- (GGTrade *)trade{
    if (!_trade) {
        _trade = [[GGTrade alloc] init];
    }
    return _trade;
}

- (GGAccount *)account{
    if (!_account) {
        _account = [[GGAccount alloc] init];
    }
    return _account;
}

- (void)setIsTransfer:(BOOL)isTransfer{
    if (_isTransfer != isTransfer) {
        _isTransfer = isTransfer;
        if (_isTransfer) {
            self.payType = PaymentTypeZZ;
        }
    }
}

- (void)setIsFinalPay:(BOOL)isFinalPay{
    if (_isFinalPay != isFinalPay) {
        _isFinalPay = isFinalPay;
        if (_isFinalPay) {
            self.payType = PaymentTypeFWK;
        }
    }
}

- (void)initialize
{
    _goodsType = GoodsTypeSafePay;
    _isOtherPay = NO;
}

- (RACSignal *)enabelSureSignal
{
    if (!_enabelSureSignal) {
        _enabelSureSignal = [RACSignal combineLatest:@[RACObserve(self.trade, tranAmount),
                                                       RACObserve(self, isOtherPay)]
                                              reduce:^id(NSString *amount,NSNumber *otherPay){
                                                  if (otherPay.boolValue == YES) {
                                                      return @(otherPay.boolValue);
                                                  } else {
                                                      return @(amount.floatValue > 0 && amount.floatValue <= [GGLogin shareUser].wallet.totalBalance.floatValue);
                                                  }
                                              }];
    }
    return _enabelSureSignal;
}

- (RACCommand *)transferCommand
{
    @weakify(self);
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[[GGApiManager request_GetDynamicCode] map:^id(NSString *value) {
            @strongify(self);
            self.trade.dynamicCode = value;
            return [RACSignal empty];
        }] then:^RACSignal *{
            @strongify(self);
            return [[[GGApiManager request_TransferAccountsWithParames:[self requestParameter]] map:^id(NSDictionary *value) {
                return [RACSignal empty];
            }] catch:^RACSignal *(NSError *error) {
                return [RACSignal error:error];
            }];
        }];
    }];
}

- (NSDictionary *)requestParameter{
    
    _trade.userId = _account.userId;
    _trade.goodsId = @(self.goodsType);
    _trade.goodsStatusId = @(self.payType);
    
    if (self.isTransfer) {
        _trade.funcFlag = @6;
    } else {
        _trade.funcFlag = @1;
    }
    
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:@[_trade.goodsId,
                                                              _trade.goodsStatusId,
                                                              _trade.tranAmount,
                                                              _trade.userId,
                                                              [GGLogin shareUser].token,
                                                              _trade.dynamicCode,
                                                              _trade.funcFlag,
                                                              _trade.password]];
    
    if (_trade.orderNo) {
        [mArray insertObject:_trade.orderNo atIndex:0];
    }

     NSString *payPassword = [mArray componentsJoinedByString:@""];
    _trade.payPassword = [[[GGHttpSessionManager sharedClient] rsaSecurity] rsaEncryptString:payPassword];
    
    NSDictionary *parmas = _trade.modelToJSONObject;
    
    return parmas;
}

@end
