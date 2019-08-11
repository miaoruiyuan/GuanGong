//
//  CWTSearchVinViewModel.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/20.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "GGViewModel.h"
#import "GGCarHistoryServiceCompany.h"
#import "GGCarHistoryReportDetailModel.h"

@interface CWTSearchVinViewModel : GGViewModel

@property(nonatomic,copy)NSString *vin;

@property(nonatomic,strong)NSNumber *balance;

@property(nonatomic,strong)GGCarHistoryServiceCompany *serviceCompany;

@property(nonatomic,strong)GGCarHistoryReportDetailModel *reportDetailModel;

@property(nonatomic,strong,readonly)RACCommand *serviceListCommand;

@property(nonatomic,strong,readonly)RACCommand *carHistoryBalanceCommand;

@property(nonatomic,strong,readonly)RACCommand *buyCarHistoryCommand;

@end
