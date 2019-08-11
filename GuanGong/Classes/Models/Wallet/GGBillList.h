//
//  GGBillList.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/15.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BillItem;

@interface GGBillList : NSObject

@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,assign)NSInteger pageSize;
@property(nonatomic,assign)NSInteger totalPage;
@property(nonatomic,assign)NSInteger totalRecord;

@property(nonatomic,strong)NSArray *result;

@end




@interface BillItem : NSObject

@property(nonatomic,copy)NSString *dealTypeName;
@property(nonatomic,copy)NSString *dealerIcon;
@property(nonatomic,strong)NSNumber *dealerId;
@property(nonatomic,copy)NSString *dealerRealName;
@property(nonatomic,copy)NSString *tranDate;
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *payId;
@property(nonatomic,assign)NSInteger keepType;
@property(nonatomic,copy)NSString *operName;
@property(nonatomic,copy)NSString *tranAmount;
@property(nonatomic,strong)NSNumber *tranFlag;
@property(nonatomic,copy)NSString *remark;

@property(nonatomic,copy)NSString *tranDateMonth;


@end

/*
 {
 dealTypeName = "\U4ea4\U6613\U5173\U95ed";
 dealerIcon = "<null>";
 dealerId = 63;
 dealerRealName = "\U7384\U56fd\U4e30";
 description = "<null>";
 keepType = 2;
 operName = "\U62c5\U4fdd\U652f\U4ed8";
 orderId = 1607180222015793972;
 orderNo = 1607180222015793;
 payId = 20160718111856722580;
 tranAmount = 50;
 tranDate = 1468811938000;
 tranFlag = 2;

 },
 
 */

