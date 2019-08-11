//
//  GGBusinessHome.h
//  GuanGong
//
//  Created by CodingTom on 2017/2/16.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGBusinessHome : NSObject

@property(nonatomic,assign)NSInteger currentMonthCarOrderCount;
@property(nonatomic,assign)NSInteger currentMonthPublishCarCount;
@property(nonatomic,assign)NSInteger currentMonthSoldCarCount;

@property(nonatomic,copy)NSArray *dayOrMonthCarCount;

@property(nonatomic,assign)NSInteger onSaleCarCount;

@property(nonatomic,assign)NSInteger totalSoldCarCount;


@end
