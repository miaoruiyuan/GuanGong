//
//  GGDatePicker.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGDatePicker.h"

@implementation GGDatePicker

- (instancetype)initWithDefaultValue:(NSArray *)defaultValue value:(NSArray *)value{
    if (self = [super init]) {
        self.defaultValue = defaultValue;
        self.value = value;
    }
    return self;
}


@end
