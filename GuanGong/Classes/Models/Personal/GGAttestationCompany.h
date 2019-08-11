//
//  GGAttestationCompany.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/10.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGAttestationCompany : NSObject

@property(nonatomic,copy)NSString *companyName;
@property(nonatomic,copy)NSString *socialCreditCode;
@property(nonatomic,copy)NSString *businessLicenceCode;

@property(nonatomic,copy)NSString *businessLicencePic;

@property(nonatomic,copy)NSString *legalPersonName;
@property(nonatomic,copy)NSString *legalPersonPhone;

@property(nonatomic,copy)NSString *identificationPosUrl;
@property(nonatomic,copy)NSString *identificationOppoUrl;

@end
