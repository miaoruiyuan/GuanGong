//
//  GGLogInViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGLogInViewModel.h"
#import "FCUUID.h"

@implementation GGLogInViewModel

- (void)initialize{
    
    //能否点击登录按钮
    _enabelLoginSignal = [RACSignal combineLatest:@[RACObserve(self, mobile),
                                                    RACObserve(self, userPassword)] reduce:^id(NSString *phone, NSString *password){
                                                        
                                                        return @(phone.length == 11 && password.length >= 6);
                                                    }];

    //能否发送验证码
    _enabelSendSignal = [RACSignal combineLatest:@[RACObserve(self, regMobile)]
                                          reduce:^id(NSString *phone){
                                              
                                              return @(phone.length == 11);
                                          }];
    //能否注册
    _enabelRegisterSignal = [RACSignal combineLatest:@[RACObserve(self, regMobile),
                                                       RACObserve(self, identifyingCode),
                                                       RACObserve(self, regPassword)] reduce:^id(NSString *phone,NSString *icode,NSString *password){
                                                           
                                                           return @(phone.length == 11 && icode.length == 6 && password.length > 0);
                                                       }];
    
    
    
}


#pragma mark - 登录
- (RACCommand *)loginCommand{
    
    @weakify(self);
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        NSString *uuid = [FCUUID uuidForDevice];
        
        NSString *deviceToken  = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        @strongify(self);
        NSDictionary *parmas = @{@"mobile":self.mobile,
                                 @"userPassword":[[[GGHttpSessionManager sharedClient] rsaSecurity] rsaEncryptString:self.userPassword],
                                 @"appName":GGAppName,
                                 @"version":[[UIApplication sharedApplication] appVersion],
                                 @"deviceToken":deviceToken ? : @"",
                                 @"machineCode":uuid,
                                 @"tokenServiceType":@1};
        
        return [[GGApiManager request_Login_WithParames:parmas]map:^id(NSDictionary *value) {
                    GGLogin *login = [GGLogin modelWithDictionary:value];
                    [[GGLogin shareUser]updateUserWithLogin:login];
            return [RACSignal empty];
        }];
    }];
}

#pragma mark - 发送验证码
- (RACCommand *)sendCodeCommand{
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[GGApiManager request_IdentifyingCode_WithMobliePhone:_regMobile] map:^id(NSString *value) {
            return [RACSignal empty];
        }];
    }];
}

#pragma mark -注册
- (RACCommand *)registerCommand{
    @weakify(self);
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        NSString *uuid = [FCUUID uuidForDevice];
        NSString *deviceToken  = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        @strongify(self);
        NSDictionary *parmas = @{@"mobile":self.regMobile,
                                 @"userPassword":[[[GGHttpSessionManager sharedClient] rsaSecurity] rsaEncryptString:self.regPassword],
                                 @"verificationCode":[[[GGHttpSessionManager sharedClient] rsaSecurity] rsaEncryptString:self.identifyingCode],
                                 @"appName":GGAppName,
                                 @"version":[[UIApplication sharedApplication] appVersion],
                                 @"deviceToken":deviceToken ? : @"",
                                 @"machineCode":uuid,
                                 @"tokenServiceType":@1};
        
        return [[GGApiManager request_Register_WithParames:parmas] map:^id(NSDictionary *value) {
            
            GGLogin *login = [GGLogin modelWithDictionary:value];
            [[GGLogin shareUser]updateUserWithLogin:login];
            
            return [RACSignal empty];
        }];
    }];

}


- (void)testAddToken:(NSString *)deviceTokenString
{
    NSString *uuid = [FCUUID uuidForDevice];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSDictionary *parameter = @{
                                @"systemVersion":systemVersion,
                                @"deviceToken":deviceTokenString,
                                @"machineCode":uuid,
                                @"tokenServiceType":@"1"
                                };
    
    [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"device/add"
                                                   withParams:parameter
                                                     andBlock:^(id data, NSError *error) {
                                                         
                                                     }];
}


@end
