//
//  GGLogin.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGLogin.h"

@interface GGLogin ()

@property(nonatomic,strong,readwrite)GGUser *user;
@property(nonatomic,strong,readwrite)GGWallet *wallet;
@property(nonatomic,strong,readwrite)GGCompanyModel *company;

@property(nonatomic,assign,readwrite)BOOL isLogin;
@property(nonatomic,copy,readwrite)NSString *token;
@property(nonatomic,assign,readwrite)BOOL haveSetPayPassword;

@end

static NSString *const kUserInfo = @"loginUserInfo";
static NSString *const kAmountInfo = @"amountInfo";
static NSString *const kCompanyInfo = @"login_company_Info";
static NSString *const kToken = @"loginToken";

@implementation GGLogin

+ (GGLogin *)shareUser{
    
    static dispatch_once_t onceToken;
    static GGLogin *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[GGLogin alloc] init];
    });
    return manager;

}

- (GGUser *)user{
    if (!_user) {
        NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
        _user = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    return _user;
}

- (GGWallet *)wallet{
    if (!_wallet) {
        NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:kAmountInfo];
        _wallet = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    return _wallet;
}
- (GGCompanyModel *)company{
    if (!_company) {
        NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:kCompanyInfo];
        _company = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    return _company;
}

- (NSString *)token{
    if (!_token) {
        _token = [[NSUserDefaults standardUserDefaults] objectForKey:kToken];
    }
    return _token;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [self modelEncodeWithCoder:aCoder];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
    }
    return [self modelInitWithCoder:aDecoder];
}


#pragma mark - 登录成功,保存
-(void)updateUserWithLogin:(GGLogin *)login{
    self.token = login.token;
    [[NSUserDefaults standardUserDefaults] setObject:self.token forKey:kToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateUser:login.user];
}

#pragma mark - 更新用户信息
- (void)updateUser:(GGUser *)user{
    self.user = user;
    if (self.company) {
        self.user.companyAuditingType = self.company.auditStatus;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *loginData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [defaults setObject:loginData forKey:kUserInfo];
    [defaults synchronize];
}

- (void)updateAmount:(GGWallet *)wallet{
    self.wallet = wallet;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *walletData = [NSKeyedArchiver archivedDataWithRootObject:wallet];
    [defaults setObject:walletData forKey:kAmountInfo];
    [defaults synchronize];
}

- (void)updateCompany:(GGCompanyModel *)company{
    self.company = company;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *companyData = [NSKeyedArchiver archivedDataWithRootObject:company];
    [defaults setObject:companyData forKey:kCompanyInfo];
    [defaults synchronize];
}

- (BOOL)haveSetPayPassword{
    
    NSNumber *payPass = [[NSUserDefaults standardUserDefaults] objectForKey:GGPaymentPassword];
    return payPass.boolValue;
}

- (BOOL)isLogin{
    if (!_isLogin) {
        _isLogin = self.user ? YES : NO;
    }
    return _isLogin;
}

- (void)logOut{
    self.user = nil;
    self.token = nil;
    self.wallet = nil;
    _isLogin = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kUserInfo];
    [defaults removeObjectForKey:kToken];
    [defaults removeObjectForKey:kAmountInfo];
    [defaults synchronize];
    
    //清除cookie
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    for (NSHTTPCookie *cookie in cookies) {
        if ([[cookie name]isEqualToString:@"JSESSIONID"]) {
            [cookieJar deleteCookie:cookie];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [((AppDelegate *)[UIApplication sharedApplication].delegate) rootViewControllerLogIn];
    });
}

@end


