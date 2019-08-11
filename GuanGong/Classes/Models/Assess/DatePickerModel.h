//
//  DatePickerModel.h
//  iautosCar
//
//  Created by three on 2016/11/21.
//  Copyright © 2016年 iautos_miaoruiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatePickerModel : NSObject

@property(nonatomic,strong)NSArray *defaultValue;
@property(nonatomic,strong)NSArray *value;
-(instancetype)initWithDefaultValue:(NSArray *)defaultValue value:(NSArray *)value;

@end
