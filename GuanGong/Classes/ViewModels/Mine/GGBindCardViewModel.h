//
//  GGBindCardViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/14.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGBank.h"
#import "GGBankAddress.h"
#import "GGBankProvince.h"

@interface GGBindCardViewModel : GGTableViewModel


@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *acctId;
@property(nonatomic,assign)NSInteger bankType;

@property(nonatomic,strong)GGBankAddress *bankAddress;
@property(nonatomic,strong)GGBankCountry *country;

@property(nonatomic,copy)NSString *sBankCode;
@property(nonatomic,copy)NSString *mobilePhone;
@property(nonatomic,copy)NSString *messageCode;

@property(nonatomic,strong)GGBank *bank;

@property(nonatomic,strong,readonly)RACSignal *enableBindSignal;
@property(nonatomic,strong,readonly)RACSignal *enableSendSMSSignal;

@property(nonatomic,strong,readonly)RACCommand *sendIdentifyCommand;
@property(nonatomic,strong,readonly)RACCommand *confirmCommand;

@end

