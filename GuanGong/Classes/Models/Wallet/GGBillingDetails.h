//
//  GGBillingDetails.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/20.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGBillingDetails : NSObject

@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,strong)NSNumber *billingId;
@property(nonatomic,assign)NSInteger isdel;
@property(nonatomic,copy)NSString *payId;
@property(nonatomic,assign)NSInteger payResult;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *statusId;
@property(nonatomic,copy)NSString *statusName;
@property(nonatomic,copy)NSString *subOrderNo;
@property(nonatomic,copy)NSString *updateTime;

@end


/*
 createTime = 1466157892000;
 id = 144;
 isdel = 0;
 operUserId = 18;
 orderNo = 1606170228570574;
 payId = "<null>";
 payResult = 1;
 price = 100;
 statusId = 18;
 statusName = "\U5168\U6b3e\U652f\U4ed8";
 subOrderNo = "<null>";
 updateTime = 1466391861000;

 */