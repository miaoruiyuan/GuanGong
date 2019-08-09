//
//  GGHeader.h
//  GuanGong
//
//  Created by 苗芮源 on 16/4/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,GGPaymentMethod) {
    GGPaymentMethodOnline =  0,  // 在线付款
    GGPaymentMethodBalance = 1,  // 余额付款
};


typedef NS_ENUM(NSInteger,GGAddAnFriendSource) {
    AddAnFriendFromAddressBook =  1,  // 通讯录
    AddAnFriendFromWeixin = 2,  //微信
    AddAnFriendFromQQ = 3,  //QQ好友
    AddAnFriendFromWeiBo = 4,  //微博
    AddAnFriendFromSearch = 5,  //手机号搜索
    AddAnFriendFromScan = 6  //二维码
    
};

UIKIT_EXTERN NSString *const GGAppName;

/*----------微信---------------------*/
UIKIT_EXTERN NSString *const APP_KEY_WEIXIN;


/*----------友盟---------------------*/
UIKIT_EXTERN NSString *const YM_APP_KEY;

/*----------阿里云---------------------*/
UIKIT_EXTERN NSString *const AL_APP_KEY;
UIKIT_EXTERN NSString *const AL_APP_SECRET;
UIKIT_EXTERN NSString *const AL_APP_CODE;

UIKIT_EXTERN NSString *const Iautos_AppKey;
UIKIT_EXTERN NSString *const Iautos_AppSecret;

UIKIT_EXTERN NSString *const Sign_FileName;
UIKIT_EXTERN NSString *const Sign_Password;
UIKIT_EXTERN NSString *const Encrypt_FileName;
UIKIT_EXTERN NSString *const GGAppKey;
UIKIT_EXTERN NSString *const HttpsDomain;



UIKIT_EXTERN NSString *const GGRechargeHelpUrl;
UIKIT_EXTERN NSString *const GGCheckCarPriceUrl;
UIKIT_EXTERN NSString *const GGLaunchScreenUrl;

UIKIT_EXTERN NSString *const GGVBankUrl;


/*----------NSNotfuncationCenter---------------------*/
UIKIT_EXTERN NSString *const GGTransferSuccessNotification;
UIKIT_EXTERN NSString *const GGPaymentSuccessNotification;
UIKIT_EXTERN NSString *const GGBindCardSuccessNotification;
UIKIT_EXTERN NSString *const GGUpdataCardListNotification;

UIKIT_EXTERN NSString *const GGAddFriendSuccessNotification;
UIKIT_EXTERN NSString *const GGOtherPaySuccessNotification;
UIKIT_EXTERN NSString *const GGRefreshBuyerListNotification;
UIKIT_EXTERN NSString *const GGRefreshSellerListNotification;

UIKIT_EXTERN NSString *const GGOtherPayListNotification;
UIKIT_EXTERN NSString *const GGCapitalClearApplySuccessNotification;

UIKIT_EXTERN NSString *const GGCarsListParameterNotification;

UIKIT_EXTERN NSString *const GGFirstGuideViewHiddenNotification;


UIKIT_EXTERN NSString *const GGBaseInfoCache;


UIKIT_EXTERN NSString *const GGFingerPay;
UIKIT_EXTERN NSString *const GGFingerLock;

UIKIT_EXTERN NSString *const GGVBankShowNewIconKey;

//设置了支付密码标识
UIKIT_EXTERN NSString *const GGPaymentPassword;


UIKIT_EXTERN CGFloat const TableViewCellHeigt;

UIKIT_EXTERN CGFloat const kLeftPadding;

