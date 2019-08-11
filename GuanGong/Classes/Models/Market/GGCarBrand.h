//
//  GGCarBrand.h
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGCarSeries,GGCarMfrs,GGSeries,GGModelList;

@interface GGCarBrand : NSObject

@property(nonatomic,strong)NSNumber *country_id;
@property(nonatomic,copy)NSString *country_name;
@property(nonatomic,strong)NSNumber *brandId;
@property(nonatomic,copy)NSString *logo;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *pinyin;
@property(nonatomic,copy)NSString *pinyin_initial;

@end

@interface GGCarSeries : NSObject

@property(nonatomic,strong)GGCarMfrs *car_mfrs;
@property(nonatomic,strong)NSArray *car_series;


@end

@interface GGCarMfrs : NSObject
@property(nonatomic,copy)NSString *iautos_name;
@property(nonatomic,strong)NSNumber *mfrsId;

@end

@interface GGSeries : NSObject

@property(nonatomic,copy)NSString *fullname;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *name_show;
@property(nonatomic,copy)NSString *pinyin;
@property(nonatomic,copy)NSString *pinyin_old;
@property(nonatomic,strong)NSNumber *seriesId;


@end



@interface GGCarModel : NSObject

@property(nonatomic,copy)NSString *brand_name;
@property(nonatomic,strong)NSNumber *brand_id;
@property(nonatomic,copy)NSString *series_name;
@property(nonatomic,strong)NSNumber *series_id;

@end



@interface GGModelList : NSObject

@property(nonatomic,copy)NSString *displacement;
@property(nonatomic,strong)NSNumber *modelId;
@property(nonatomic,strong)NSNumber *model_id;
@property(nonatomic,copy)NSString *emissions_name;
@property(nonatomic,copy)NSString *model_name;
@property(nonatomic,copy)NSString *n_price;
@property(nonatomic,copy)NSString *sub_name;
@property(nonatomic,copy)NSString *transmission_type_name;
@property(nonatomic,copy)NSString *full_name;
@property(nonatomic,copy)NSString *version_year;
@property(nonatomic,assign)BOOL is_turbo;
@property(nonatomic,strong)NSNumber *brand_id;
@property(nonatomic,strong)NSNumber *series_id;


@end


/*
 "country_id" = 7;
 "country_name" = "\U4e2d\U56fd";
 heat = 446;
 id = 102;
 logo = "http://img5.iautos.cn/webpage/2014/0709/20140709103920519.png";
 name = "\U4f9d\U7ef4\U67ef";
 pinyin = yiweike;
 "pinyin_initial" = Y;

 */




/* 车系*****
 fullname = "\U5965\U8fea200";
 id = 4;
 name = 200;
 "name_show" = "\U5965\U8fea200";
 pinyin = aodi200;
 "pinyin_old" = aodi200;
 */








/*车系列表
 
 {
 displacement = "1.8";
 "emissions_name" = "\U56fd\U2163";
 "extra_name" = "";
 "full_name" = "\U5965\U8feaA4L-1.8T-MT-30TFSI\U8212\U9002\U578b\U4eac\U2164(\U56fd\U2163)";
 id = 114771;
 "is_turbo" = 1;
 "model_id" = 114771;
 "model_name" = "\U8212\U9002\U578b";
 "new_price" = "27.28";
 "sub_name" = 30TFSI;
 "transmission_type_id" = 99;
 "transmission_type_name" = "\U624b\U52a8";
 "version_year" = 2013;
 },
 
 */
