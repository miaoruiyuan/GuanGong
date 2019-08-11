//
//  GGRewardViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/8/16.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGViewModel.h"

@class RewardInfo;

@interface GGRewardViewModel : GGViewModel


@property(nonatomic,strong)RewardInfo *rewardInfo;


//订单号
@property(nonatomic,copy)NSString *orderNo;
//打赏金额
@property(nonatomic,copy)NSString *tranAmount;

@property(nonatomic,strong,readonly)RACSignal *enbleRewardSignal;


@property(nonatomic,strong,readwrite)RACCommand *rewardInfoCommond;
//打赏
@property(nonatomic,strong,readwrite)RACCommand *rewardCommond;
@end


@interface RewardInfo : NSObject

@property(nonatomic,strong)NSArray *amts;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,strong)NSNumber *userId;


@end
