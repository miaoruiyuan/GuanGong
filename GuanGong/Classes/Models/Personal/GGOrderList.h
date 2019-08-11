//
//  GGOrderList.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  订单类型
 */
typedef NS_ENUM(NSInteger,OrderPaymentType) {
    /**
     *  付尾款
     */
    OrderPaymentTypeWK = 1,
    /**
     *  全款
     */
    OrderPaymentTypeQK = 2,
    /**
     *  转账
     */
    OrderPaymentTypeZZ = 3
};

/**
 *  订单状态
 */
typedef NS_ENUM(NSInteger,OrderStatusType) {
    /**
     *  付订金
     */
    OrderStatusTypeFDJ = 2,
    /**
     *  付尾款
     */
    OrderStatusTypeFWK = 5,
    /**
     *  交易成功
     */
    OrderStatusTypeJYCG = 8,
    /**
     *  申请退款
     */
    OrderStatusTypeSQTK = 9,
    /**
     *  已退款成功
     */
    OrderStatusTypeTKCG = 10,
    /**
     *  确认收货失败
     */
    OrderStatusTypeSHSB = 15,
    /**
     *  已退款失败
     */
    OrderStatusTypeTKSB = 17,
    /**
     *  全款支付
     */
    OrderStatusTypeQKZF = 18,
    /**
     *  卖家拒绝退款
     */
    OrderStatusTypeJJTK = 19,
    /**
     *  卖家同意退款
     */
    OrderStatusTypeTYTK = 20,
    /**
     *  72小时自动拒绝退款
     */
    OrderStatusTypeZDJJTK = 21,
    /**
     *  15天自动确认收货
     */
    OrderStatusTypeZDQRSH = 22,
    /**
     *  申请客服介入
     */
    OrderStatusTypeKFJR = 23,
    /**
     *  申请退货退款
     */
    OrderStatusTypeTHTK = 24,
    /**
     *  卖家同意退货退款
     */
    OrderStatusTypeTYTHTK = 25,
    /**
     *  卖家拒绝退货退款
     */
    OrderStatusTypeJJTHTK = 26,
    /**
     *  买家已退货
     */
    OrderStatusTypeMJYTH = 27,
    /**
     *  卖家收货已退款
     */
    OrderStatusTypeMJSHTK = 28,
    /**
     *  卖家收货退款失败
     */
    OrderStatusTypeMJTKSB = 29,
    /**
     *  卖家确认收货
     */
    OrderStatusTypeMJQRSH = 31
};

@interface GGOrderList : NSObject

@property(nonatomic,copy)NSString *dealerIcon;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *order_description;
@property(nonatomic,strong)NSNumber *goodsTypeId;
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,assign)BOOL isBuyer;
@property(nonatomic,assign)BOOL payOver;
@property(nonatomic,assign)BOOL hasApplyReturn;
@property(nonatomic,assign)BOOL hasPayAnother;
@property(nonatomic,assign)BOOL hasReward;
@property(nonatomic,strong)NSNumber *isdel;
@property(nonatomic,copy)NSString *nextStepStatusName;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,assign)CGFloat price;
@property(nonatomic,strong)NSNumber *dealerId;
@property(nonatomic,copy)NSString *dealerName;
@property(nonatomic,copy)NSString *dealerRealName;
@property(nonatomic,copy)NSString *dealerMobile;
@property(nonatomic,assign)OrderStatusType statusId;
@property(nonatomic,assign)OrderPaymentType statusType;
@property(nonatomic,copy)NSString *updateTime;


@end


/*
 
 {
 createTime = 1466150711000;
 dealerIcon = "<null>";
 dealerId = 24;
 dealerMobile = 18101356403;
 dealerName = 18101356403;
 description = test;
 goodsTypeId = 2;
 hasApplyReturn = 0;
 id = 107;
 isBuyer = 1;
 isdel = 0;
 nextStepStatusName = "\U5f85\U652f\U4ed8\U5c3e\U6b3e";
 orderNo = 1606170202868234;
 payOver = 0;
 price = 12;
 returnPrice = "<null>";
 statusId = 2;
 statusType = 1;
 updateTime = 1467876287000;

 },

 */
