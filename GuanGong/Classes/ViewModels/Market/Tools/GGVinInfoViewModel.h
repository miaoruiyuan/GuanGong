//
//  GGVinInfoViewModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGViewModel.h"
#import "GGCarHistoryServiceCompany.h"
#import "GGVinResultDetailModel.h"

@interface GGVinInfoViewModel : GGViewModel

@property(nonatomic,copy)NSString *vin;

@property(nonatomic,strong)NSNumber *balance;

@property(nonatomic,strong,readonly)RACCommand *vinInfoBalanceCommand;

@property(nonatomic,strong,readonly)RACCommand *vinGetDiffModelsCommand;

@property(nonatomic,strong,readonly)RACCommand *buyVinInfoCommand;

@property(nonatomic,strong,readonly)RACCommand *getVinInfoDetailCommand;

@property(nonatomic,strong)NSArray *vinResults;

@property(nonatomic,strong)GGVinResultDetailModel *vinInfoDetail;

@end
