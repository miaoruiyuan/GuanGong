//
//  GGCheckCarSeriesViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGViewModel.h"
#import "GGCarBrand.h"

@interface GGCheckCarSeriesViewModel : GGViewModel


@property(nonatomic,strong)NSNumber *brandId;
@property(nonatomic,copy)NSString *brandName;
@property(nonatomic,strong)NSNumber *seriesId;
@property(nonatomic,copy)NSString *seriesName;
@property(nonatomic,strong)NSNumber *title;


@property(nonatomic,strong)RACCommand *brandCommand;
@property(nonatomic,strong)RACCommand *seriesCommand;

@property(nonatomic,strong)NSMutableDictionary *brands;
@property(nonatomic,strong)NSArray *series;


@end
