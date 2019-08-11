//
//  GGDatePicker.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGDatePicker : NSObject
@property(nonatomic,strong)NSArray *defaultValue;
@property(nonatomic,strong)NSArray *value;
- (instancetype)initWithDefaultValue:(NSArray *)defaultValue value:(NSArray *)value;
@end
