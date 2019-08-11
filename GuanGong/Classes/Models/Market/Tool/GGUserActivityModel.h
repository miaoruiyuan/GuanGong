//
//  GGUserActivityModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/18.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GGUserActivityStatusType) {
    GGUserActivityStatusCanJoin = 0,
    GGUserActivityStatusJoined,
    GGUserActivityStatusCanReceive,
    GGUserActivityStatusReceived
};

@interface GGUserActivityModel : NSObject

// ['0-可参加 1-已参加 2-可领取 3-已领取']: 状态,
@property (nonatomic , assign) GGUserActivityStatusType        status;
@property (nonatomic , copy) NSString           *activityId;
@property (nonatomic , copy) NSString           *des;

@end
