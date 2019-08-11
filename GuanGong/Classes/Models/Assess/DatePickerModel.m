//
//  DatePickerModel.m
//  iautosCar
//
//  Created by three on 2016/11/21.
//  Copyright © 2016年 iautos_miaoruiyuan. All rights reserved.
//

#import "DatePickerModel.h"

@implementation DatePickerModel

-(instancetype)initWithDefaultValue:(NSArray *)defaultValue value:(NSArray *)value{
    if (self = [super init]) {
        self.defaultValue = defaultValue;
        self.value = value;
    }
    return self;
}

@end
