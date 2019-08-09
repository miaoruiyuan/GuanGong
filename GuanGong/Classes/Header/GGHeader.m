//
//  GGHeader.m
//  GuanGong
//
//  Created by 苗芮源 on 16/4/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>



NSString *const GGAppName = @"guangong";
NSString *const APP_KEY_WEIXIN = @"wx1dfe642ac95a1a12";

NSString *const YM_APP_KEY = @"57cd54ba67e58eb0250011b4";
NSString *const AL_APP_KEY = @"23515151";
NSString *const AL_APP_SECRET = @"3561f51f2b49aa295b4102320ecd62db";
NSString *const AL_APP_CODE = @"39cfd0a304c2411784ba5e13e7428cbe";

NSString *const Iautos_AppKey = @"197812345";
NSString *const Iautos_AppSecret = @"88b5b59dc95ac546aabe71261ab0d35b";


#if DEVELOPMENT

NSString *const Sign_FileName = @"sign_private_key";
NSString *const Sign_Password = @"9diw*2#12";
NSString *const Encrypt_FileName = @"encrypt_public_key";
NSString *const HttpsDomain = @"gg.iautos.cn";
NSString *const GGAppKey = @"0FE52DE7DD5E52263379FACF68AC9046";

NSString *const GGLaunchScreenUrl = @"http://192.168.1.250:16600/finance-gg-m/m/html/guanInterface.html";
NSString *const GGVBankUrl = @"http://v.csiautos.cn/h5/index.html?source_from=guanerye";


#else

NSString *const Sign_FileName = @"sign_private_key_p";
NSString *const Sign_Password = @"9diw*2#12";
NSString *const Encrypt_FileName = @"encrypt_public_key_p";
NSString *const HttpsDomain = @"guangong.iautos.cn";
NSString *const GGAppKey = @"E85795D3247F0EA2D6E00755D7E1DD87";

NSString *const GGLaunchScreenUrl = @"https://guangong.iautos.cn/m/html/guanInterface.html";

NSString *const GGVBankUrl = @"https://v.iautos.cn/h5/index.html?source_from=guanerye";

//NSString *const GGVBankUrl = @"https://iautos.cn/beijing/";


#endif



NSString *const GGRechargeHelpUrl = @"https://guangong.iautos.cn/m/html/guanPaymentMethod.html";
NSString *const GGCheckCarPriceUrl = @"https://guangong.iautos.cn/m/html/guanHcbl.html";



//转账成功
NSString *const GGTransferSuccessNotification = @"kGGTransferSuccessNotification";
//担保支付成功
NSString *const GGPaymentSuccessNotification = @"kGGPaymentSuccessNotification";
//绑卡成功
NSString *const GGBindCardSuccessNotification = @"KGGBindCardSuccessNotification";

//更新银行卡列表
NSString *const GGUpdataCardListNotification = @"kGGBindCardSuccessNotification";

//添加好友成功
NSString *const GGAddFriendSuccessNotification = @"kGGAddFriendSuccessNotification";
//代付成功
NSString *const GGOtherPaySuccessNotification = @"kGGOtherPaySuccessNotification";
//担保支付
NSString *const GGRefreshBuyerListNotification = @"kBuyerListNotification";
NSString *const GGRefreshSellerListNotification = @"kSellerListNotification";

//代付
NSString *const GGOtherPayListNotification = @"kGGOtherPayListNotification";
//清分申请成功
NSString *const GGCapitalClearApplySuccessNotification = @"kGGCapitalClearApplySuccessNotification";

//车源列表通知
NSString *const GGCarsListParameterNotification = @"kGGCarsListParameterNotification";

//引导页面消失
NSString *const GGFirstGuideViewHiddenNotification = @"GGFirstGuideViewHiddenNotification";

//指纹
NSString *const GGFingerPay  = @"kFingerPay";

NSString *const GGFingerLock = @"kFingerLock";

NSString *const GGPaymentPassword  = @"paymentPassword";

NSString *const GGBaseInfoCache = @"KBaseInfoCache";

NSString *const GGVBankShowNewIconKey = @"GG_Key_IS_Show_VBank";

CGFloat const kLeftPadding = 20;
