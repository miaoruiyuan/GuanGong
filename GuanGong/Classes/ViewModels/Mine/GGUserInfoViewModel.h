//
//  GGUserInfoViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGUser.h"


@interface GGUserInfoViewModel : GGTableViewModel

@property(nonatomic,strong)GGUser *user;

@property(nonatomic,strong,readonly)RACSignal *enableReviseSignal;
@property(nonatomic,strong,readonly)RACCommand *editCommand;
@property(nonatomic,strong,readonly)RACCommand *getBaseUserInfoCommand;
@property(nonatomic,strong,readonly)RACCommand *getAcountInfoCommand;


@end
