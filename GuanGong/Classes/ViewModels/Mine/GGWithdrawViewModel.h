//
//  GGWithdrawViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/14.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGBankCard.h"

@interface GGWithdrawViewModel : GGTableViewModel

@property(nonatomic,copy)NSString *dynamicCode;
@property(nonatomic,copy)NSString *tranAmount;
@property(nonatomic,copy)NSString *acctId;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *phoneLast4Code;

@property(nonatomic,copy)NSString *messageCode;


@property(nonatomic,strong)GGBankCard *bankCard;

//是否可以提现
@property(nonatomic,strong,readonly)RACSignal *enableSignal;

@property(nonatomic,strong)RACCommand *bankCardsCommand;

@property(nonatomic,strong,readonly)RACCommand *getOrderCommand;
@property(nonatomic,strong,readonly)RACCommand *doneCommand;

@property(nonatomic,strong,readonly)RACCommand *unBindingCommand;

@property(nonatomic,strong,readonly)RACCommand *calculationFeeCommand;

@property(nonatomic,strong)NSMutableArray *cards;


@end
