//
//  GGLogin.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGUser.h"
#import "GGWallet.h"
#import "GGCompanyModel.h"

@interface GGLogin : NSObject<NSCoding>

@property(nonatomic,copy)NSString *identifyingCode;

@property(nonatomic,strong,readonly)GGUser *user;
@property(nonatomic,strong,readonly)GGWallet *wallet;
@property(nonatomic,strong,readonly)GGCompanyModel *company;

@property(nonatomic,strong)NSMutableArray *cards;

@property(nonatomic,assign,readonly)BOOL isLogin;

@property(nonatomic,copy,readonly)NSString *token;

@property(nonatomic,assign,readonly)BOOL haveSetPayPassword; //检测时候设置了支付密码

+ (GGLogin *)shareUser;


/**
 *  登出
 */
- (void)logOut;


/**
 *  更新user信息
 *
 *  @param user user description
 */
- (void)updateUser:(GGUser *)user;

/**
 *  更新账户信息
 *
 *  @param account Model
 */
- (void)updateAmount:(GGWallet *)wallet;

/**
 *  登录时更新一下
 *
 *  @param user user description
 */
- (void)updateUserWithLogin:(GGLogin *)login;

/**
 更新企业认证信息
 @param company 企业认证信息
 */
- (void)updateCompany:(GGCompanyModel *)company;


@end



