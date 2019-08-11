//
//  GGCompanyModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/14.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGCompanyModel.h"

@implementation GGCompanyModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self modelEncodeWithCoder:aCoder];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {}
    return [self modelInitWithCoder:aDecoder];
}

@end
