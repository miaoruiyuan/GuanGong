//
//  GGUser.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/24.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGCompanyModel.h"

/**
 *  实名认证审核状态
 */
typedef NS_ENUM(NSInteger,AuditingType) {
 
    /**
     *  审核通过
     */
    AuditingTypePass = 1,
    /**
     *  审核未通过
     */
    AuditingTypeInvaild = 2,
    /**
     *  审核中
     */
    AuditingTypeWillAudit = 3,
    /**
     *  没有提交过审核
     */
    AuditingTypeNoSubmit = 4
};

@interface GGUser : NSObject<NSCoding>

@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,retain)NSNumber *isdel;
@property(nonatomic,retain)NSNumber *status;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userPassword;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *auditingDescription;
@property(nonatomic,copy)NSString *auditingTime;
@property(nonatomic,assign)AuditingType auditingType;
@property(nonatomic,copy)NSString *auditingUserId;
@property(nonatomic,copy)NSString *cityId;
@property(nonatomic,copy)NSString *companyName;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *qrCodeUri;
@property(nonatomic,copy)NSString *headPic;

@property(nonatomic,copy)NSString *location;
@property(nonatomic,copy)NSString *payPassword;
@property(nonatomic,copy)NSString *provinceId;
@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *zipCode;

@property(nonatomic,copy)NSString *province;
@property(nonatomic,copy)NSString *city;


@property(nonatomic,copy)NSString *identification;
@property(nonatomic,copy)NSString *identificationOppoUrl;
@property(nonatomic,copy)NSString *identificationPosUrl;

@property(nonatomic,assign)CompanyAuditingType companyAuditingType;

@end



/*
 auditingDescription = "<null>";
 auditingTime = "<null>";
 auditingType = 4;
 cityId = "<null>";
 companyName = "<null>";
 email = "<null>";
 headPic = "<null>";
 id = 75;
 isdel = 0;
 location = "<null>";
 mobile = 18010097052;
 provinceId = "<null>";
 qrCodeUri = "https://gg.iautos.cn:16343/finance-gg/ggApi/user/getQrcode?params=0BDE367ADE83EFAF331E47C123C5C10A";
 realName = "<null>";
 status = 1;
 updateTime = 1468914164000;
 userName = "\U4e09\U56fd\U540d\U5c06";
 zipCode = "<null>";
 
 */

