//
//  GGBankRechargeViewModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/7/20.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGViewModel.h"
#import "GGBankRechargeRateModel.h"
#import "GGUnionPayOpenModel.h"
#import "GGBankRechargeListModel.h"

@interface GGBankRechargeViewModel : GGViewModel

@property(nonatomic,strong)GGBankRechargeRateModel *rateModel;
@property(nonatomic,strong,readonly)RACCommand *getChargeRateCommand;

@property(nonatomic,strong)NSMutableArray *cardArray;
@property(nonatomic,strong)GGBankRechargeListModel *defaultBankModel;
@property(nonatomic,strong,readonly)RACCommand *getOpenedCardListCommand;

@property(nonatomic,strong)GGUnionPayOpenModel *payOpenModel;
@property(nonatomic,strong,readonly)RACCommand *openCardApplyCommand;

@property(nonatomic,strong)NSString *rechargeAmount;
@property(nonatomic,strong,readonly)RACCommand *calculationFeeCommand;

@property (nonatomic,strong)NSString *payOrderNO;
@property(nonatomic,strong,readonly)RACCommand *sendPaySMSCommand;
@property(nonatomic,strong,readonly)RACCommand *paySMSConfirmCommand;


@property (nonatomic,strong)NSString *password;

@end
