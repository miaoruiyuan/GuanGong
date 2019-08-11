//
//  GGBankAddress.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/23.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGBankAddress : NSObject

@property(nonatomic,strong)NSNumber *bankClsCode;
@property(nonatomic,strong)NSNumber *bankNo;
@property(nonatomic,strong)NSNumber *cityCode;
@property(nonatomic,strong)NSNumber *payId;
@property(nonatomic,strong)NSNumber *status;

@property(nonatomic,copy)NSString *logNo;
@property(nonatomic,copy)NSString *bankName;

@end


/*
 {
 bankClsCode = 103;
 bankName = "\U4e2d\U56fd\U519c\U4e1a\U94f6\U884c\U80a1\U4efd\U6709\U9650\U516c\U53f8\U5317\U4eac\U91d1\U9f0e\U652f\U884c";
 bankNo = 103100003240;
 cityCode = 1000;
 logNo = "<null>";
 payId = "<null>";
 status = 1;

 */