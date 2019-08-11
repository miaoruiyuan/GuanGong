//
//  GGLogInViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/6.
//  Copyright © 2016年 iautos. All rights reserved.
//


#import "GGViewModel.h"

@interface GGLogInViewModel : GGViewModel


//登录
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *userPassword;

@property(nonatomic,strong,readonly)RACSignal *enabelLoginSignal;
@property(nonatomic,strong,readonly)RACCommand *loginCommand;



//注册
@property(nonatomic,copy)NSString *regMobile;
@property(nonatomic,copy)NSString *regPassword;
@property(nonatomic,copy)NSString *identifyingCode;


@property(nonatomic,strong,readonly)RACSignal *enabelSendSignal;
@property(nonatomic,strong,readonly)RACCommand *sendCodeCommand;

@property(nonatomic,strong,readonly)RACSignal *enabelRegisterSignal;
@property(nonatomic,strong,readonly)RACCommand *registerCommand;



@end
