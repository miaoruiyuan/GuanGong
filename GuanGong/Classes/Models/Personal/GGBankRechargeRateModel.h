//
//  GGBankRechargeRateModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/7/21.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGBankRechargeRateModel : NSObject

@property(nonatomic,copy)NSString *creditRateRemark;
@property(nonatomic,copy)NSString *debitRateRemark;
@property(nonatomic,assign)double debitRate;
@property(nonatomic,assign)double creditRate;
@property(nonatomic,copy)NSString *chargeRateRemark;

@end
