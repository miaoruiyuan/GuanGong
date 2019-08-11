//
//  NSArray+Common.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "NSArray+Common.h"
#import <AddressBook/AddressBook.h>

@implementation NSArray (Common)

+ (NSArray *)configArrayWithResource:(NSString *)resource{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:resource ofType:@"plist"];
    NSArray *configArray = [NSArray arrayWithContentsOfFile:plistPath];
    return configArray;
}

@end
