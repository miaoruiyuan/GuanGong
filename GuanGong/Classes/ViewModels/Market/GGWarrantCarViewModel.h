//
//  GGWarrantCarViewModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/2/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGViewModel.h"
#import "GGCar.h"
#import "GGFormItem.h"

@interface GGWarrantCarViewModel : GGViewModel

@property (nonatomic,copy)NSArray *dataSource;

@property (nonatomic,strong)RACCommand *appointmentCommand;

@property(nonatomic,strong)GGCar *checkCar;



@end
