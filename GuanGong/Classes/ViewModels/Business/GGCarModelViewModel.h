//
//  GGCarModelViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckCarSeriesViewModel.h"

@interface GGCarModelViewModel : GGCheckCarSeriesViewModel

@property(nonatomic,strong)RACCommand *yearsCommand;
@property(nonatomic,strong)RACCommand *modelsCommand;
@property(nonatomic,strong)NSArray *years;
@property(nonatomic,strong)NSArray *models;

@end
