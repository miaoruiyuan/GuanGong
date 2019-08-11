//
//  GGBillInfo.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGBillInfo : NSObject


@property(nonatomic,copy)NSNumber *dealerId;
@property(nonatomic,copy)NSString *dealTypeName;
@property(nonatomic,copy)NSString *dealerIcon;
@property(nonatomic,copy)NSString *dealerRealName;
@property(nonatomic,copy)NSString *goodsName;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *goodsRemark1;
@property(nonatomic,copy)NSString *goodsRemark2;
@property(nonatomic,copy)NSString *goodsRemark3;
@property(nonatomic,assign)NSInteger goodsType;
@property(nonatomic,assign)NSInteger keepType;
@property(nonatomic,copy)NSString *operName;
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *payId;
@property(nonatomic,copy)NSString *tranAmountStr;
@property(nonatomic,copy)NSString *tranDateStr;
@property(nonatomic,assign)NSInteger tranFlag;

@property(nonatomic,copy)NSString *handFeeStr;

@property(nonatomic,assign)NSInteger dealerIsUser;//对方是否为个人用户 0否 1是

@end



/*
 {
 data =     {
 dealTypeName = "\U51bb\U7ed3\U4e2d";
 dealerIcon = "http://img3.csiautos.cn/guangong/2016/0922/20160922154809227.jpg";
 dealerId = 18;
 dealerRealName = "\U5cb3\U78ca";
 description = "<null>";
 goodsName = "\U865a\U62df\U5546\U54c1";
 goodsRemark1 = "<null>";
 goodsRemark2 = "<null>";
 goodsRemark3 = "<null>";
 goodsType = 2;
 keepType = 1;
 operName = "\U62c5\U4fdd\U652f\U4ed8";
 orderId = 16090202535441502997;
 orderNo = 1609020253544150;
 payId = 20160902171353570324;
 title = "<null>";
 tranAmount = "0.7";
 tranAmountStr = "0.70";
 tranDate = 1472807634000;
 tranDateStr = "2016-09-02 17:13:54";
 tranFlag = 1;
 };
 responseCode = 100000;
 responseMessage = success;
 responseTime = "2016-10-25 10:32:03";
 }

 */
