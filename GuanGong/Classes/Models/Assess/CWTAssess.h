//
//  CWTAssess.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/1/4.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWTAssess : NSObject

@property (nonatomic , assign) NSInteger  localSaveID;

@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *purchase_year;

@property(nonatomic,copy)NSString *mileage;

@property (nonatomic, copy) NSString *modelSimpleName;
@property(nonatomic,strong) NSNumber *model_simple_id;

@property (nonatomic, copy) NSString *brandName;
@property(nonatomic,strong) NSNumber *modelSimpleId;

@property (nonatomic, copy) NSString *seriesName;
@property (nonatomic, copy) NSString *purchaseYear;
@property (nonatomic, copy) NSString *version_year;
@property (nonatomic, copy) NSString *model_id;

@property(nonatomic,copy)NSString *province_id;
@property(nonatomic,copy) NSString *city_id;
@property(nonatomic,copy)NSString *city_proper_id;

@property(nonatomic,copy)NSString  *province_name;
@property(nonatomic,copy)NSString  *city_name;
@property(nonatomic,copy)NSString  *city_proper_name;

@property(nonatomic,copy)NSString  *first_reg_date;
@property(nonatomic,assign)BOOL  is_history;
@property(nonatomic,strong)NSNumber  *log_id;


@property (nonatomic , copy) NSString              * emissions_name;
@property(nonatomic,copy)NSString *title;
@property (nonatomic , copy) NSString              * title_l;

@property(nonatomic,copy)NSString *update_time;
@property(nonatomic,copy)NSString *create_time; 

@end
