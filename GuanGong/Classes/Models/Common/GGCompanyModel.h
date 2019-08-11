//
//  GGCompanyModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/14.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  实名认证审核状态
 */
typedef NS_ENUM(NSInteger,CompanyAuditingType) {
    /**
     *  待审核
     */
    CompanyAuditingTypeWait = 1,
    /**
     *  审核通过
     */
    CompanyAuditingTypePass = 2,
    /**
     *  审核未通过
     */
    CompanyAuditingTypeInvaild = 3,
    /**
     *  没有提交过审核
     */
    CompanyAuditingTypeNoSubmit = 0
};

@interface GGCompanyModel : NSObject<NSCoding>

@property(nonatomic,copy)NSString *companyName;
@property(nonatomic,copy)NSString *legalPersonName;
@property(nonatomic,copy)NSString *legalPersonPhone;
@property(nonatomic,copy)NSString *socialCreditCode;
@property(nonatomic,copy)NSString *businessLicenceCode;
@property(nonatomic,copy)NSString *taxRegCode;
@property(nonatomic,copy)NSString *businessLicencePic;
@property(nonatomic,copy)NSString *identificationOppoUrl;
@property(nonatomic,copy)NSString *identificationPosUrl;

@property(nonatomic,retain)NSNumber *status;//0-正常,1-失效:

//@property(nonatomic,assign)CompanyAuditingType auditStatus;
@property(nonatomic,assign)CompanyAuditingType auditStatus;

@property(nonatomic,copy)NSString *auditDescription;
@property(nonatomic,copy)NSString *applyUserName;
@property(nonatomic,copy)NSString *auditUserName;
@property(nonatomic,copy)NSString *auditTime;

@end
