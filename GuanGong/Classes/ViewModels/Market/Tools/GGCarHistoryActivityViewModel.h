//
//  GGCarHistoryActivityViewModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/18.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGViewModel.h"
#import "GGUserActivityModel.h"

@interface GGCarHistoryActivityViewModel : GGViewModel

//1-绑卡成功赠送车史查询4次；2-实名认证赠送车史查询2次；3-实名认证赠送VIN查询10次；4-绑卡成功赠送VIN查询20次
@property (nonatomic,strong)NSString *activityId;

@property (nonatomic,strong)GGUserActivityModel *activityModel;

//活动操作
@property(nonatomic,strong,readonly)RACCommand *executeActivityCommand;

// 获取活动信息
@property(nonatomic,strong,readonly)RACCommand *getActivityCommand;

@end
