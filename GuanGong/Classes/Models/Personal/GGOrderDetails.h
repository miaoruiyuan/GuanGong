//
//  GGOrderDetails.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/9.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGGoodsInfo.h"
#import "GGOrderList.h"

@class GGOrderRecords;

@interface GGOrderDetails : NSObject

@property(nonatomic,copy)NSString *createOrderTime;
@property(nonatomic,strong)GGGoodsInfo *goodsInfo;
@property(nonatomic,assign)BOOL hasApplyReturn;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,strong)NSArray *orderRecords;
@property(nonatomic,strong)NSArray *transOrderRecords;
@property(nonatomic,assign)BOOL hasPayAnother;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *returnPrice;
@property(nonatomic,copy)NSString *applyReturnPics;
@property(nonatomic,assign)NSInteger payOver;

@property(nonatomic,assign)OrderStatusType statusId;

@property(nonatomic,assign)BOOL isAutoSureReceive;
@property(nonatomic,copy)NSString *autoSureReceiveBeginTime;
@property(nonatomic,assign)NSInteger autoSureReceiveCountDown;

@end

@interface GGOrderRecords : NSObject

@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,strong)NSNumber *payResult;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *orderPics;
@property(nonatomic,copy)NSString *statusName;
@property(nonatomic,copy)NSString *subOrderNo;
@property(nonatomic,strong)NSNumber *operType;
@property(nonatomic,assign)OrderStatusType statusId;
@property(nonatomic,strong)NSNumber *recordId;
@property(nonatomic,copy)NSString *remark;//description

@property(nonatomic,assign)NSInteger status;

@end


/*
 {
 createOrderTime = 1466496661000;
 goodsInfo =     {
 description = "<null>";
 id = "<null>";
 pics = "<null>";
 title = "<null>";
 };
 orderNo = 1606210221151978;
 orderRecords =     (
 {
 createTime = 1466496661000;
 id = 198;
 isdel = 0;
 orderNo = 1606210221151978;
 payResult = 1;
 price = 10;
 statusName = "\U4ed8\U5b9a\U91d1";
 subOrderNo = 1606210221151978198;
 },
 {
 createTime = 1466546339000;
 id = 204;
 isdel = 0;
 orderNo = 1606210221151978;
 payResult = "<null>";
 price = 1;
 statusName = "\U4ed8\U5c3e\U6b3e";
 subOrderNo = "<null>";
 },
 {
 createTime = 1466546388000;
 id = 205;
 isdel = 0;
 orderNo = 1606210221151978;
 payResult = "<null>";
 price = 1;
 statusName = "\U4ed8\U5c3e\U6b3e";
 subOrderNo = "<null>";
 },
 {
 createTime = 1466546504000;
 id = 206;
 isdel = 0;
 orderNo = 1606210221151978;
 payResult = "<null>";
 price = 10;
 statusName = "\U4ed8\U5c3e\U6b3e";
 subOrderNo = "<null>";
 },
 {
 createTime = 1467943509000;
 id = 231;
 isdel = 0;
 orderNo = 1606210221151978;
 payResult = "<null>";
 price = "<null>";
 statusName = "\U7533\U8bf7\U9000\U8d27\U9000\U6b3e";
 subOrderNo = "<null>";
 },
 {
 createTime = 1467944074000;
 id = 232;
 isdel = 0;
 orderNo = 1606210221151978;
 payResult = "<null>";
 price = "<null>";
 statusName = "\U5356\U5bb6\U540c\U610f\U9000\U8d27\U9000\U6b3e";
 subOrderNo = "<null>";
 }
 );
 }
 
 */
