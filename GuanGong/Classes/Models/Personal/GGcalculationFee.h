//
//  GGcalculationFee.h
//  GuanGong
//
//  Created by CodingTom on 2017/3/3.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

// 提现手续费 返回的数据 model

@interface GGcalculationFee : NSObject

@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *fee;
@property(nonatomic,copy)NSString *feeType;
@property(nonatomic,copy)NSString *remark;

@end
