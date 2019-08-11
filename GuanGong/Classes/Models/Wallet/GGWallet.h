//
//  GGWallet.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGWallet : NSObject<NSCoding>

@property(nonatomic,strong)NSNumber *custAcctId;
@property(nonatomic,copy)NSString *custName;
@property(nonatomic,assign)NSInteger custType;
@property(nonatomic,copy)NSString *logNo;
@property(nonatomic,strong)NSNumber *payId;
@property(nonatomic,copy)NSString *reserve;
@property(nonatomic,strong)NSNumber *thirdCustId;

@property(nonatomic,strong)NSNumber *totalBalance;
@property(nonatomic,strong)NSNumber *totalFreezeAmount;
@property(nonatomic,strong)NSNumber *totalTranOutAmount;

@property(nonatomic,copy)NSString *tranDate;


@end




/*
 
 
 custAcctId = 888100008106403;
 custName = "<null>";
 custType = 0;
 logNo = "<null>";
 payId = 20160613155455698712;
 reserve = "";
 thirdCustId = 11204416541220243x;
 totalBalance = 99843;
 totalFreezeAmount = 9;
 totalTranOutAmount = 99843;
 tranDate = "<null>";

 */
