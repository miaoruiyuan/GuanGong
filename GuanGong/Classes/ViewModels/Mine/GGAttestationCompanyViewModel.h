//
//  GGAttestationCompanyViewModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/6.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGAttestationCompany.h"

@interface GGAttestationCompanyViewModel : GGTableViewModel

@property(nonatomic,assign)BOOL isSocialCreditCode;

@property(nonatomic,strong)GGAttestationCompany *attestationCompany;

@property(nonatomic,strong,readonly)RACSignal *enableSubmit;

@property(nonatomic,strong,readonly)RACCommand *attestationCommand;

- (void)setAttestationDefaultData;  

@end

