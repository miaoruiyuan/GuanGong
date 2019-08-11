//
//  GGCarHistoryRechargeOrderModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/14.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGCarHistoryServiceCompany.h"
#import "GGSearvicePriceListModel.h"

@interface GGCarHistoryRechargeOrderModel : NSObject

@property (nonatomic , copy) NSString              *orderNo;
@property (nonatomic , copy) NSString              *des;

@property (nonatomic , copy) NSString              *payId;
@property (nonatomic , copy) NSString              *operUserId;
@property (nonatomic , copy) NSString              *operRealUserName;

@property (nonatomic , strong) GGCarHistoryServiceCompany      *service;
@property (nonatomic , strong) GGSearvicePriceListModel        *price;

@end
