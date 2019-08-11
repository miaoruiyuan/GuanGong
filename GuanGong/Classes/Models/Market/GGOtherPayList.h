//
//  GGOtherPayList.h
//  GuanGong
//
//  Created by 苗芮源 on 16/8/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,OtherPayStatus) {
    OtherPayStatusDCL = 0,
    OtherPayStatusYDF,
    OtherPayStatusYJJ,
    OtherPayStatusYQX,
    OtherPayStatusNone
};

@class GGOtherPayBuyer,GGOtherPayPayer,GGOtherPaySaler;

@interface GGOtherPayList : NSObject

@property(nonatomic,copy)NSString *amount;
@property(nonatomic,strong)GGOtherPayBuyer *buyer;
@property(nonatomic,strong)GGOtherPayPayer *payer;
@property(nonatomic,strong)GGOtherPaySaler *saler;
@property(nonatomic,copy)NSString *createTimeStr;
@property(nonatomic,assign)OtherPayStatus status;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,strong)NSNumber *applyId;
@property(nonatomic,copy)NSString *subOrderNo;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,strong)NSNumber *goodsStatusId;
@property(nonatomic,assign)NSInteger salerIsUser;




@end



@interface GGOtherPayBuyer : NSObject

@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *headPic;
@property(nonatomic,strong)NSNumber *buyerId;

@end

@interface GGOtherPayPayer : NSObject

@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *headPic;
@property(nonatomic,strong)NSNumber *payerId;

@end

@interface GGOtherPaySaler : NSObject

@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *headPic;
@property(nonatomic,strong)NSNumber *salerId;

@end


/*
 {
 amount = "9.9";
 
  ----------------------------------- ----------------------------------- -----------------------------------
 
 buyer =                 {
 auditingDescription = "<null>";
 auditingTime = 1465714655000;
 auditingType = 1;
 cityId = 273;
 companyName = diyichewang;
 email = "yuelei@iautos.cn";
 headPic = "http://img3.csiautos.cn/guangong/2016/0727/20160727104008732.jpg";
 id = 18;
 isdel = 0;
 location = "\U8fbd\U5b81 \U846b\U82a6\U5c9b";
 mobile = 13810623572;
 provinceId = 8;
 qrCodeUri = "https://gg.iautos.cn:16343/finance-gg/ggApi/user/getQrcode?params=3F89DAC791ABDC86852CEE8DA3A8039C";
 realName = Yuelei;
 status = 1;
 updateTime = 1471575278000;
 userName = "yue leii";
 zipCode = "\U5929\U6d25";
 };
 
 
 createTime = 1471779764000;
 createTimeStr = "2016-08-21 19:42:44";
 goodsStatusId = 2;
 id = 31;
 orderNo = "<null>";
 payId = "<null>";
 
  ----------------------------------- ----------------------------------- -----------------------------------
 
 payer =                 {
 auditingDescription = "\U5ba1\U6838\U901a\U8fc7";
 auditingTime = 1465714655000;
 auditingType = 1;
 cityId = 343;
 companyName = "\U7b2c\U4e00\U8f66\U7f51\U6d4b\U8bd5\U90e8\U5730\U94c1\U5e7f\U544a";
 email = "<null>";
 headPic = "http://img3.csiautos.cn/guangong/2016/0725/20160725102705922.jpg";
 id = 24;
 isdel = 0;
 location = "\U5609\U8bda\U6709\U6811";
 mobile = 18101356403;
 provinceId = 5;
 qrCodeUri = "https://gg.iautos.cn:16343/finance-gg/ggApi/user/getQrcode?params=3F89DAC791ABDC86852CEE8DA3A8039C";
 realName = "\U674e\U76df\U73cd";
 status = 1;
 updateTime = 1471766410000;
 userName = 18101356403;
 zipCode = "\U6cb3\U5317 \U5f20\U5bb6\U53e3";
 };
 remark = "<null>";
 
 
 ----------------------------------- ----------------------------------- -----------------------------------
 
 saler =                 {
 auditingDescription = "\U5ba1\U6838\U901a\U8fc7";
 auditingTime = 1465714655000;
 auditingType = 1;
 cityId = 343;
 companyName = "\U7b2c\U4e00\U8f66\U7f51\U6d4b\U8bd5\U90e8\U5730\U94c1\U5e7f\U544a";
 email = "<null>";
 headPic = "http://img3.csiautos.cn/guangong/2016/0725/20160725102705922.jpg";
 id = 24;
 isdel = 0;
 location = "\U5609\U8bda\U6709\U6811";
 mobile = 18101356403;
 provinceId = 5;
 qrCodeUri = "https://gg.iautos.cn:16343/finance-gg/ggApi/user/getQrcode?params=3F89DAC791ABDC86852CEE8DA3A8039C";
 realName = "\U674e\U76df\U73cd";
 status = 1;
 updateTime = 1471766410000;
 userName = 18101356403;
 zipCode = "\U6cb3\U5317 \U5f20\U5bb6\U53e3";
 };
 
  ----------------------------------- ----------------------------------- -----------------------------------
 
 status = 0;
 subOrderNo = "<null>";
 updateTime = 1471779764000;
 updateTimeStr = "2016-08-21 19:42:44";
 },
 */
