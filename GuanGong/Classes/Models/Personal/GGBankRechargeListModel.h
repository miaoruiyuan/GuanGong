//
//  GGGGBankRechargeListModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/7/24.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGBankRechargeListModel : NSObject

@property(nonatomic,copy)NSString *openId;
@property(nonatomic,copy)NSString *cardType;
@property(nonatomic,copy)NSString *plantBankName;
@property(nonatomic,copy)NSString *accNo;
@property(nonatomic,assign)BOOL isDefault;
@property(nonatomic,copy)NSString *plantBankId;
@property(nonatomic,copy)NSString *telephone;
@property(nonatomic,copy)NSString *logo;


@property(nonatomic,copy)NSString *singleLimit;
@property(nonatomic,copy)NSString *dailyLimit;

@end
