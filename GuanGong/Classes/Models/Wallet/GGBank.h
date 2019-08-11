//
//  GGBank.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGBank : NSObject<NSCoding>

@property(nonatomic,copy)NSString *bankName;
@property(nonatomic,strong)NSNumber *bankCode;
@property(nonatomic,strong)NSNumber *bankCode1;
@property(nonatomic,copy)NSString *logo;
@property(nonatomic,strong)NSNumber *payId;

@end


/*
 "bankCode": "103100000026",
 "bankCode1": "103",
 "bankName": "中国农业银行",
 "logo": "http://photo.iautos.cn/guangong/banklogo/banklogo-nongyeyinhang-2x.png"

 */