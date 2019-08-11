//
//  GGCheckOrderList.h
//  GuanGong
//
//  Created by 苗芮源 on 16/9/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  订单状态
 */
typedef NS_ENUM(NSInteger,CheckOrderStatus) {
    CheckOrderStatusAll = -1,
    /**
     *  待确认
     */
    CheckOrderStatusBeContinued = 0,
    /**
     *  待支付
     */
    CheckOrderStatusBePayment,
    /**
     *  待检测
     */
    CheckOrderStatusBeCheck,
    /**
     *  检测完成
     */
    CheckOrderStatusDone,
    /**
     *  关闭
     */
    CheckOrderStatusClosed
};

@interface GGCheckOrderList : NSObject

@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *privinceName;
@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,copy)NSString *checkOrderNo;
@property(nonatomic,copy)NSString *checkTime;
@property(nonatomic,copy)NSString *checkServiceName;
@property(nonatomic,copy)NSString *checkReportUrl;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,strong)NSNumber *orderId;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *saleName;
@property(nonatomic,copy)NSString *saleTel;
@property(nonatomic,strong)NSNumber *saleId;

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *vin;
@property(nonatomic,assign)CheckOrderStatus orderStatus;

@end



/*
 {
 address = "<null>";
 checkOrderNo = 0147331686087107716;
 checkReportUrl = "<null>";
 checkServiceName = "\U597d\U8f66\U4f2f\U4e50";
 checkTime = "<null>";
 createTime = "2016-09-08 14:40:59";
 description = "<null>";
 id = 18;
 orderNo = 1609080426250061;
 orderStatus = 0;
 payId = "<null>";
 price = "<null>";
 saleId = "<null>";
 saleName = Miao;
 saleTel = 13333500032;
 subOrderNo = "<null>";
 title = "\U963f\U65af\U987f\U9a6c\U4e01One-77";
 vin = 12345678901234567;
 }

 */
