//
//  GGNewCarDetailViewModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/9.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGViewModel.h"
#import "GGNewCarDetailModel.h"

@interface GGNewCarDetailViewModel : GGViewModel

@property(nonatomic,strong,readonly)RACCommand *carDetailCommand;

@property(nonatomic,strong)GGNewCarDetailModel *carDetailModel;

@end
