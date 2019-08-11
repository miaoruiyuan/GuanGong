//
//  CWTVinHistoryViewModel.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/21.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "GGTableViewModel.h"
//#import "CWTVinHistory.h"

#import "GGCarHistoryServiceCompany.h"
#import "GGCarHistoryReportDetailModel.h"
#import "GGVinResultDetailModel.h"

@interface CWTVinHistoryViewModel : GGTableViewModel

@property(nonatomic,strong)GGCarHistoryServiceCompany *serviceCompany;

@property(nonatomic,strong)GGCarHistoryReportDetailModel *reportDetailModel;

@property(nonatomic,strong)GGVinResultDetailModel *vinInfoDetailModel;

//保养历史记录列表
@property(nonatomic,strong,readonly)RACCommand *carHistoryListCommand;

//获取保养记录详情
@property(nonatomic,strong,readonly)RACCommand *carHistoryDetailCommand;


//VIN查询列表
@property(nonatomic,strong,readonly)RACCommand *vinInfoListCommand;

//获取VIN详情
@property(nonatomic,strong,readonly)RACCommand *vinInfoDetailCommand;


@end
