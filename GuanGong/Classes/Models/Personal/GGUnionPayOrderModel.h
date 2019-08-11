//
//  GGUnionPayOrderModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/7/21.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGUnionPayOrderModel : NSObject

@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *bnsSysNo;
@property(nonatomic,copy)NSString *bnsFlowNo;
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,copy)NSString *currency;
@property(nonatomic,copy)NSString *origAmount;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *payDate;

@end
