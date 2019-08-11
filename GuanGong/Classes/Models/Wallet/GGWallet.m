//
//  GGWallet.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGWallet.h"

@implementation GGWallet

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self modelEncodeWithCoder:aCoder];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {}
    return [self modelInitWithCoder:aDecoder];
}

@end
