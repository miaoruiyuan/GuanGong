//
//  GGTrade.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGTrade : NSObject
/**
 *  用户ID
 */
@property(nonatomic,strong)NSNumber *userId;
/**
 *  商品类型 1:车 2:担保支付
 */
@property(nonatomic,strong)NSNumber *goodsId;
/**
 *  商品支付类型 2:付定金 5:付尾款 18:全款支付 12:转账
 */
@property(nonatomic,strong)NSNumber *goodsStatusId;
/**
 *  担保（冻结）金额
 */
@property(nonatomic,copy)NSString *tranAmount;
/**
 *  描述
 */
@property(nonatomic,copy)NSString *reserve;
/**
 *  1：下单预支付 （付款方→担保） 6：直接支付（会员A→会员B）
 */
@property(nonatomic,strong)NSNumber *funcFlag;
/**
 *  动态码
 */
@property(nonatomic,copy)NSString *dynamicCode;
/**
 *  支付密码
 */
@property(nonatomic,copy)NSString *password;

/**
 *  订单号,如果没有就在加密的字符串里去掉
 */
@property(nonatomic,copy)NSString *orderNo;

/**
 *  支付密码
 */
@property(nonatomic,copy)NSString *payPassword;

@end
