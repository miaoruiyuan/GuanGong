//
//  StartAssessModel.h
//  bluebook
//
//  Created by three on 2017/5/4.
//  Copyright © 2017年 iautos_miaoruiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StartAssessModel : NSObject


@property (nonatomic, copy) NSString *modelSimpleName;
@property (nonatomic, copy) NSString *model_simple_id;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *seriesName;
@property (nonatomic, copy) NSString *purchaseYear;

@property (nonatomic, copy) NSString *first_reg_date;
@property (nonatomic, copy) NSString *mileage;

@property (nonatomic, copy) NSString *city_id;
@property (nonatomic, copy) NSString *city_name;
@property(nonatomic,assign) NSInteger city_proper_id;
@property (nonatomic, copy) NSString *city_proper_name;
@property(nonatomic,assign) NSInteger province_id;
@property (nonatomic, copy) NSString *province_name;

@end
