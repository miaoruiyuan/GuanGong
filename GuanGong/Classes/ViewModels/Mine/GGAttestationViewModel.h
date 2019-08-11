//
//  GGAttestationViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/30.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"

@class GGAttestation;

@interface GGAttestationViewModel : GGTableViewModel

@property(nonatomic,strong)GGAttestation *attestation;

@property(nonatomic,strong,readonly)RACSignal *enableSubmit;

@property(nonatomic,strong,readonly)RACCommand *attestationCommand;

//@property(nonatomic,strong,readonly)RACCommand *reloadData;

- (void)setAttestationDefaultData;

@end



@interface GGAttestation : NSObject

@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *identification;
@property(nonatomic,copy)NSString *identificationPosUrl;
@property(nonatomic,copy)NSString *identificationOppoUrl;
@property(nonatomic,copy)NSNumber *cityId;
@property(nonatomic,copy)NSNumber *provinceId;
@property(nonatomic,copy)NSString *location;

@end
