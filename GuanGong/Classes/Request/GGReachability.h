//
//  GGReachability.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/20.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface GGReachability : NSObject


+ (GGReachability *)shareReachability;
- (NetworkStatus)currentNetStatus;

@end
