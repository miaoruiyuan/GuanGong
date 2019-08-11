//
//  GGCheckCarViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGCheckCar.h"
@interface GGCheckCarViewModel : GGTableViewModel

@property(nonatomic,strong)GGCheckCar *checkCar;

@property(nonatomic,strong)RACCommand *appointmentCommand;
@property(nonatomic,strong)RACCommand *vinCommand;


@end
