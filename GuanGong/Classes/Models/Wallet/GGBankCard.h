//
//  GGBankCard.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGBankCard : NSObject

@property(nonatomic,copy)NSString *bankName;
@property(nonatomic,assign)NSInteger bankType;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,strong)NSNumber *custAcctId;
@property(nonatomic,copy)NSString *bankTitle;
@property(nonatomic,copy)NSString *custName;
@property(nonatomic,copy)NSString *bankLogo;
@property(nonatomic,strong)NSNumber *cardId;
@property(nonatomic,copy)NSString *idCode;
@property(nonatomic,strong)NSNumber *idType;
@property(nonatomic,copy)NSString *identification;

@property(nonatomic,assign)NSInteger isdel;
@property(nonatomic,copy)NSString *logNo;
@property(nonatomic,copy)NSString *mobilePhone;
@property(nonatomic,copy)NSString *payId;

@property(nonatomic,copy)NSString *sBankCode;
@property(nonatomic,assign)NSInteger unBinding;
@property(nonatomic,copy)NSString *updateTime;



@end


/*
 
 bankCode = "<null>";
 bankName = "\U5de5\U5546\U94f6\U884c";
 bankType = 2;
 createTime = 1465811711000;
 custAcctId = 888100008106272;
 custName = "\U5cb3\U78ca";
 id = 10;
 idCode = 6215590200003689254;
 idType = 1;
 identification = 110103198810080919;
 isdel = 0;
 logNo = "<null>";
 mobilePhone = 15600736701;
 payId = "<null>";
 sBankCode = 102100099996;
 unBinding = 1;
 updateTime = 1465814089000;
 */
