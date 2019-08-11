//
//  GGFriendInfo.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGFriendsList.h"
#import "GGCompanyModel.h"

@interface GGFriendInfo : NSObject

@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *companyName;
@property(nonatomic,strong)NSNumber *contactId;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *provinceName;
@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,assign)BOOL isFriend;
@property(nonatomic,copy)NSString *iconUrl;
@property(nonatomic,assign)FriendAuditStatus auditingType;
@property(nonatomic,strong)GGCompanyModel *company;


@end


/*
 {
 cityName = "\U6b66\U6c49";
 companyName = "";
 contactId = 123;
 phone = 13881819191;
 provinceName = "";
 realName = cba;
 remark = abccba;
 userId = 100;
 userName = abc;
 }

 */
