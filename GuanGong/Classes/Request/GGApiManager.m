//
//  GGApiManager.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/2.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGApiManager.h"

static GGApiManager *shared_manager = nil;

@implementation GGApiManager

+ (instancetype)sharedManager{
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}


+ (RACSignal *)request_IdentifyingCode_WithMobliePhone:(NSString *)mobile{
    
    NSDictionary *parames = @{@"mobile":mobile};
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"user/getVerificationCode"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}



+ (RACSignal *)request_ChangePhoneSendSMS:(NSDictionary *)requestDic{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"account/modifyPhoneApply"
                                                       withParams:requestDic
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

+ (RACSignal *)request_ChangePhoneVerify:(NSDictionary *)requestDic{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"account/modifyPhoneVerify"
                                                       withParams:requestDic
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
//                                                                 if (DEVELOPMENT) {
//                                                                     kTipAlert(@"短信验证码：%@",data);
//                                                                 }
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}
+ (RACSignal *)request_NewPhoneSendSMS:(NSDictionary *)requestDic{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"account/sendMessageCode"
                                                       withParams:requestDic
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];

                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

+ (RACSignal *)request_NewPhoneVerify:(NSDictionary *)requestDic{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"account/verifyMessageCode"
                                                       withParams:requestDic
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
//                                                                 if (DEVELOPMENT) {
//                                                                     kTipAlert(@"短信验证码：%@",data);
//                                                                 }
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

#pragma mark - 注册
+ (RACSignal *)request_Register_WithParames:(NSDictionary *)parames{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"user/registe"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }

                                                         }];
        
        return nil;
    }];
    
}

#pragma mark - 登录
+ (RACSignal *)request_Login_WithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"user/login"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
}


#pragma mark - 补全用户信息
+ (RACSignal *)request_EditUserInfoWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"user/editInfo"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];

}

#pragma mark-  实名认证
+ (RACSignal *)request_CompleteInfomationWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"user/completionInfo"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
       
        return nil;
    }];
}

#pragma mark -  企业认证
+ (RACSignal *)request_ApplyCompanyWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"company/applyCompany"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

#pragma mark - 修改密码
+ (RACSignal *)request_RevisePassword_WithResetPassword:(NSString *)resetPass oldPassword:(NSString *)oldPass{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSDictionary *parmas = @{@"newPassword":[[[GGHttpSessionManager sharedClient] rsaSecurity] rsaEncryptString:resetPass],
                                 @"oldPassword":[[[GGHttpSessionManager sharedClient] rsaSecurity] rsaEncryptString:oldPass]};

        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"user/modifyPasswordByOld"
                                                       withParams:parmas
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
}

#pragma mark - 根据验证码找回密码
+ (RACSignal *)request_FindPassword_WithParames:(NSDictionary *)parames{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"user/modifyPasswordByVC"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];

}


#pragma mark - 判断是否设置过支付密码
+ (RACSignal *)request_hasSetPayPassword{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"user/hasSetPayPassword"
                                                       withParams:nil
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

#pragma mark - 设置支付密码
+ (RACSignal *)request_ResetPayPassword_WithPayPassword:(NSString *)password andIdentifyCode:(NSString *)icode{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *parmas = @{@"payPassword":[[[GGHttpSessionManager sharedClient] rsaSecurity] rsaEncryptString:password],
                                 @"verificationCode":[[[GGHttpSessionManager sharedClient] rsaSecurity] rsaEncryptString:icode]};
        
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"user/setPayPassword"
                                                       withParams:parmas
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
}


#pragma mark - 修改支付密码
+ (RACSignal *)request_RevisePaymentPassword_WithResetPassword:(NSString *)resetPass oldPassword:(NSString *)oldPass{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSDictionary *parmas = @{@"newPayPassword":[[[GGHttpSessionManager sharedClient] rsaSecurity] rsaEncryptString:resetPass],
                                 @"oldPayPassword":[[[GGHttpSessionManager sharedClient] rsaSecurity] rsaEncryptString:oldPass],
                                 @"mobile":[GGLogin shareUser].user.mobile};
        [[GGHttpSessionManager sharedClient] requestJsonDataWithPath:@"user/modifyPayPasswordByOld"
                                                          withParams:parmas
                                                      withMethodType:Post
                                                            andBlock:^(id data, NSError *error) {
                                                                
                                                                if (error) {
                                                                    [subscriber sendError:error];
                                                                }else{
                                                                    [subscriber sendNext:data];
                                                                    [subscriber sendCompleted];
                                                                }
                                                                
                                                                
                                                            }];

        return nil;
    }];
    
    
}




#pragma mark - 获取账户信息
+ (RACSignal *)request_SearchUserInfo_WithMobile:(NSString *)mobile{
    
    NSDictionary *parmas = @{@"mobilePhone":mobile};
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"account/getByMobilePhone"
                                                       withParams:parmas
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
    
}

#pragma mark - 先获取动态码
+ (RACSignal *)request_GetDynamicCode{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"account/getDynamicCode"
                                                       withParams:nil
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}



#pragma mark - 转账
+ (RACSignal *)request_TransferAccountsWithParames:(NSDictionary *)parames{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[GGHttpSessionManager sharedClient] requestJsonDataWithPath:@"order/trade"
                                                          withParams:parames
                                                      withMethodType:Post
                                                            andBlock:^(id data, NSError *error) {
                                                                if (error) {
                                                                    [subscriber sendError:error];
                                                                }else{
                                                                    [subscriber sendNext:data];
                                                                    [subscriber sendCompleted];
                                                                }
                                                            }];

        return nil;
    }];
}



#pragma mark - 我的银行卡
+ (RACSignal *)request_MineBankLists{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[GGHttpSessionManager sharedClient] requestJsonDataWithPath:@"account/getBindingCardInfo"
                                                          withParams:nil
                                                      withMethodType:Post
                                                            andBlock:^(id data, NSError *error) {
                                                                if (error) {
                                                                    [subscriber sendError:error];
                                                                }else{
                                                                    [subscriber sendNext:data];
                                                                    [subscriber sendCompleted];
                                                                }
                                                            }];

        
        return nil;
    }];
    
    
}


#pragma mark - 解绑银行卡
+ (RACSignal *)request_unBingingBankCardWithParames:(NSDictionary *)parmas{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"account/unbindingCard"
                                                       withParams:parmas
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
}


#pragma mark - 获取账户变更记录
+ (RACSignal *)request_BillLists_WithParmas:(NSDictionary *)parmas{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] requestJsonDataWithPath:@"account/accountRecord"
                                                          withParams:parmas
                                                      withMethodType:Post
                                                            andBlock:^(id data, NSError *error) {
                                                                if (error) {
                                                                    [subscriber sendError:error];
                                                                }else{
                                                                    [subscriber sendNext:data];
                                                                    [subscriber sendCompleted];
                                                                }
                                                            }];
        return nil;
    }];
}

#pragma mark - 账单详情
+ (RACSignal *)request_BillDetail_WithPayId:(NSString *)number{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] requestJsonDataWithPath:@"account/accountRecordInfo"
                                                          withParams:@{@"payId":number}
                                                      withMethodType:Post
                                                            andBlock:^(id data, NSError *error) {
                                                                if (error) {
                                                                    [subscriber sendError:error];
                                                                }else{
                                                                    [subscriber sendNext:data];
                                                                    [subscriber sendCompleted];
                                                                }
                                                            }];
        return nil;
    }];

}


#pragma mark - 获取账户详情
+ (RACSignal *)request_AccountInfo{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] requestJsonDataWithPath:@"account/baseInfo"
                                                          withParams:nil
                                                      withMethodType:Post
                                                            andBlock:^(id data, NSError *error) {
                                                                
                                                                if (error) {
                                                                    [subscriber sendError:error];
                                                                }else{
                                                                    [subscriber sendNext:data];
                                                                    [subscriber sendCompleted];
                                                                }
                                                            }];
        return nil;
    }];
}

#pragma mark - 获取用户基本信息
+ (RACSignal *)request_getUserBaseInfo{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"user/getBaseInfo"
                                                       withParams:nil
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

#pragma mark - 获取开户行网点
+ (RACSignal *)request_getBankAddressWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"account/getBankInfoCode"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                             
                                                         }];
        
        return nil;
    }];

}

#pragma mark - 绑定银行卡第一步,获取验证码
+ (RACSignal *)request_getMessageCodeBeforeBindBankCardWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"account/bindingCard"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }

                                                         }];
        
        return nil;
    }];
}

#pragma mark - 确认绑定银行卡
+ (RACSignal *)request_BindBankCardCaptchaVerifyParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"account/bindCardCaptchaVerify"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

#pragma mark - 提现前收到订单号
+ (RACSignal *)request_BeforeDrawCashGetOrderNoWithParameter:(NSDictionary *)parame{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] requestJsonDataWithPath:@"account/applyTakeCashCaptchaCode"
                                                          withParams:parame
                                                      withMethodType:Post
                                                            andBlock:^(id data, NSError *error) {
                                                                if (error) {
                                                                    [subscriber sendError:error];
                                                                }else{
                                                                    [subscriber sendNext:data];
                                                                    [subscriber sendCompleted];
                                                                }
                                                            }];

        return nil;
    }];
    
    
}



#pragma mark - 提现
+ (RACSignal *)request_WithDrawCashWithParames:(NSDictionary *)parsmes{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"account/withdraw"
                                                       withParams:parsmes
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}


#pragma mark - 获取联系人列表
+ (RACSignal *)request_MyFriensList{
   return [self request_MyFriensList_WithKw:nil];
}
+ (RACSignal *)request_MyFriensList_WithKw:(NSString *)kw{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *parmas = nil;
        if (kw) {
            parmas = @{@"kw":kw,@"type":@1};
        }else{
           parmas = @{@"type":@1}; 
        }
        
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"contact/list"
                                                       withParams:parmas
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];

        return nil;
    }];
}
#pragma mark - 新的朋友
+ (RACSignal *)request_MyNewFriensList{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"contact/list"
                                                       withParams:@{@"type":@2}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];

}

#pragma mark - 添加联系人
+ (RACSignal *)request_AddAnFriend_WithMobile:(NSString *)mobile formType:(GGAddAnFriendSource )type{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSDictionary *parmas = @{@"mobile":mobile,@"from":@(type)};
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"contact/add"
                                                       withParams:parmas
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

#pragma mark - 查看某个联系人的详细信息
+ (RACSignal *)request_CheckFriendInfo_WithContactId:(NSNumber *)contactId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"contact/info"
                                                       withParams:@{@"contactId":contactId}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 查看某个联系人的详细信息 手机号
+ (RACSignal *)request_CheckFriendInfo_WithMobile:(NSString *)mobile{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"contact/info"
                                                       withParams:@{@"mobile":mobile}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
    
}

#pragma mark - 删除一个好友
+ (RACSignal *)request_DeleteAnFriend_WithContactId:(NSNumber *)contactId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"contact/del"
                                                       withParams:@{@"contactId":contactId}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 修改好友备注
+ (RACSignal *)request_EditFriendInfo_WithContactId:(NSNumber *)contactId remark:(NSString *)remark{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *parmas = @{@"contactId":contactId,@"remark":remark};
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"contact/edit"
                                                       withParams:parmas
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
   

}

#pragma mark - 账单列表
+ (RACSignal *)request_PaymentOrderListWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/orderList"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 账单详情
+ (RACSignal *)request_PaymentOrderDetailsWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/orderInfo"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];

        
        return nil;
    }];
}

#pragma mark - 上传交易信息
+ (RACSignal *)request_SubmitDealInfoWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/seller/uploadGoodInfo"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}


#pragma mark - 申请退货
+ (RACSignal *)request_ApplicationForRefundWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/buyer/applyReturnGoods"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 修改申请退货
+ (RACSignal *)request_ReviseRefundWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/buyer/updateReturnApply"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 卖家拒绝退款退货
+ (RACSignal *)request_RefusedRefundWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/seller/dealReturn"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
    
}





#pragma mark - 买家确认收货
+ (RACSignal *)request_BuyerConfirmGoodsWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/buyer/sureRecive"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}


#pragma mark - 卖家确认收货
+ (RACSignal *)request_SealerConfirmGoodsWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/seller/reciveReturn"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}


#pragma mark - 获取最近的联系人
+ (RACSignal *)request_LastContacts{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/lastContacts"
                                                       withParams:nil
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

#pragma mark - 邀请记录
+ (RACSignal *)request_InvitationRecordsWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"invitation/successUsers"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 获取打赏信息
+ (RACSignal *)request_RewardInfo{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/getRewardDetail"
                                                       withParams:nil
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}
#pragma mark - 打赏
+ (RACSignal *)request_RewardWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/transReward"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 代付申请
+ (RACSignal *)request_ApplyPaymentWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/payAnother/apply"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}
#pragma mark - 代付申请列表
+ (RACSignal *)request_ApplyListWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/payAnother/applyList"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 申请代付详情
+ (RACSignal *)request_ApplyDetailWithApplyId:(NSNumber *)applyId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/payAnother/applyDetail"
                                                       withParams:@{@"id":applyId}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 取消/拒绝代付
+ (RACSignal *)request_CancelApplyWithApplyId:(NSNumber *)applyId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/payAnother/applyCancel"
                                                       withParams:@{@"id":applyId}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 同意代付
+ (RACSignal *)request_AgreeApplyWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"order/payAnother/applyTrans"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 提交清分申请
+ (RACSignal *)request_SubmitCapitalClearApplyWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"capitalClear/apply"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 清分申请List
+ (RACSignal *)request_CapitalClearApplyListWithPage:(NSNumber *)page{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"capitalClear/applyList"
                                                       withParams:@{@"page":page}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 清分申请详情
+ (RACSignal *)request_CapitalClearDetailWithApplyId:(NSNumber *)applyId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"capitalClear/applyDetail"
                                                       withParams:@{@"id":applyId}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 获取所有车辆品牌
+ (RACSignal *)request_CarBrandsList{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGIautosSessionManager sharedClient] getJsonDataWithPath:@"car/brand/search"
                                                        withParams:nil
                                                          andBlock:^(id data, NSError *error) {
                                                              if (error) {
                                                                  [subscriber sendError:error];
                                                              }else{
                                                                  [subscriber sendNext:data];
                                                                  [subscriber sendCompleted];
                                                              }
                                                          }];
        
        return nil;
    }];
}

#pragma mark - 获取品牌对应的车系
+ (RACSignal *)request_CarSeriesListWithBrandId:(NSNumber *)bId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGIautosSessionManager sharedClient] getJsonDataWithPath:@"car/series/search_mfrs"
                                                        withParams:@{@"brand_id":bId}
                                                          andBlock:^(id data, NSError *error) {
                                                              if (error) {
                                                                  [subscriber sendError:error];
                                                              }else{
                                                                  [subscriber sendNext:data];
                                                                  [subscriber sendCompleted];
                                                              }
                                                              
                                                          }];
        return nil;
    }];
}
#pragma mark - 获取车系对应的年份列表
+ (RACSignal *)request_CarYearsListWithSeriesId:(NSNumber *)sId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGIautosSessionManager sharedClient] getJsonDataWithPath:@"car/model/purchase_year"
                                                        withParams:@{@"series_id":sId}
                                                          andBlock:^(id data, NSError *error) {
                                                              if (error) {
                                                                  [subscriber sendError:error];
                                                              }else{
                                                                  [subscriber sendNext:data];
                                                                  [subscriber sendCompleted];
                                                              }
                                                              
                                                          }];
        return nil;
    }];
}

#pragma mark - 根据年份和车系获取对应的车型
+ (RACSignal *)request_CarModelsListWithSeriesId:(NSNumber *)sId purYear:(NSString *)year{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGIautosSessionManager sharedClient] getJsonDataWithPath:@"car/model/simple_search_price"
                                                        withParams:@{@"series_id":sId,@"purchase_year":year}
                                                          andBlock:^(id data, NSError *error) {
                                                              if (error) {
                                                                  [subscriber sendError:error];
                                                              }else{
                                                                  [subscriber sendNext:data];
                                                                  [subscriber sendCompleted];
                                                              }
                                                              
                                                          }];
        return nil;
    }];

}

#pragma mark - 预约检车
+ (RACSignal *)request_appointmentCheckCarWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"check/createCheckOrder"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 预约检测订单列表
+ (RACSignal *)request_checkCarOrderWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"check/checkOrderList"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 检测订单详情
+ (RACSignal *)request_checkCarOrderDetailWithOrderId:(NSNumber *)orderId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"check/checkOrderInfo"
                                                       withParams:@{@"id":orderId}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];

}

#pragma mark - 根据vin识别车型
+ (RACSignal *)request_autoDiscriminateCarWithVin:(NSString *)vin{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGIautosSessionManager sharedClient] getJsonDataWithPath:@"car/vin/model"
                                                        withParams:@{@"vin":vin}
                                                          andBlock:^(id data, NSError *error) {
                                                              if (error) {
                                                                  [subscriber sendError:error];
                                                              }else{
                                                                  [subscriber sendNext:data];
                                                                  [subscriber sendCompleted];
                                                              }
                                                              
                                                          }];
        return nil;
    }];

}

#pragma mark -根据vin识别车型 ,带Vin校验
+ (RACSignal *)request_getCarModelWithVin:(NSString *)vin checkVinExist:(BOOL)exist{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"car/getCarModelByVin"
                                                       withParams:@{@"vin":vin,@"checkVinExis":@(exist)}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];

}

#pragma mark - 添加我的地址
+ (RACSignal *)request_addNewAddressWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"address/add"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];

        return nil;
    }];

}
#pragma mark - 我的地址列表
+ (RACSignal *)request_getAddressList{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"address/list"
                                                       withParams:nil
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
    

}

#pragma mark - 设置默认地址
+ (RACSignal *)request_setDefultAddressWithAddressId:(NSNumber *)addressId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"address/setDefault"
                                                       withParams:@{@"id":addressId}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];

}

#pragma mark - 编辑地址
+ (RACSignal *)request_editAddressWithParames:(NSDictionary *)parames{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"address/edit"
                                                       withParams:parames
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];

}

#pragma mark - 删除地址
+ (RACSignal *)request_deleteAnAddressWithAddressId:(NSNumber *)addressId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"address/delete"
                                                       withParams:@{@"id":addressId}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];

}

#pragma mark - 发布||编辑一辆车
+ (RACSignal *)request_releaseAnCarWithParameter:(NSDictionary *)parameter{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"car/saveCar"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
}

#pragma mark - 车源管理列表
+ (RACSignal *)request_vehicleManagerListWithParameter:(NSDictionary *)parameter{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"car/searcher"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
}

#pragma mark - 车辆详情
+ (RACSignal *)request_carDetailsWithCarId:(NSNumber *)carId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"car/getCar"
                                                       withParams:@{@"id":carId}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];

}

#pragma mark - 删除一辆车
+ (RACSignal *)request_deleteCarByCarId:(NSNumber *)carId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"car/delCar"
                                                       withParams:@{@"id":carId}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
}

#pragma mark - 车辆下单
+ (RACSignal *)request_placeAnCarOrderWithParameter:(NSDictionary *)parameter{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"carOrder/create"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
}

#pragma mark - 车辆订单列表
+ (RACSignal *)request_carsOrderListWithParameter:(NSDictionary *)parameter{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"carOrder/orderList"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
}

#pragma mark - 订单详情
+ (RACSignal *)request_carsOrderDetailWithOrderNo:(NSString *)orderNo{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"carOrder/detail"
                                                       withParams:@{@"orderNo":orderNo}
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];

}

#pragma mark - 修改车辆成交价格
+ (RACSignal *)request_modifyCarDealPriceWithParameter:(NSDictionary *)parameter{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"carOrder/updateDealPrice"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

#pragma mark - 生意页面信息
+ (RACSignal *)request_getBusinessDataWithParameter:(NSDictionary *)parameter{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"business/home"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
}

#pragma mark - 用户退出登录
+ (RACSignal *)request_userLogoutWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"user/logout"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
}

#pragma mark - 获取提现手续费
+ (RACSignal *)request_CalculationFeeWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"fee/calculationFee"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
}

#pragma mark - 验证用户身份证
+ (RACSignal *)request_CheckCardIDWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"user/verifyIdentification"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}
#pragma mark - 抢购的新车列表
+ (RACSignal *)request_GetNewCarListWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"newCar/searcher"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

#pragma mark - 抢购的新车详情
+ (RACSignal *)request_GetNewCarDetailWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"newCar/carDetail"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        return nil;
    }];
}

#pragma mark - 新车抢购车辆下单
+ (RACSignal *)request_GetNewCarOrderWithParameter:(NSDictionary *)parameter{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"newCarOrder/createNewCarOrder"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
}

@end
