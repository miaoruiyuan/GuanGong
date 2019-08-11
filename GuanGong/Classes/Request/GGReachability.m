//
//  GGReachability.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/20.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGReachability.h"

@interface GGReachability ()

@property(nonatomic,strong)Reachability *netConnectionReach;
@end

@implementation GGReachability

+(GGReachability *)shareReachability{
    static dispatch_once_t onceToken;
    static GGReachability *reachablility = nil;
    dispatch_once(&onceToken, ^{
        reachablility = [[GGReachability alloc] init];
    });
    return reachablility;
}
-(instancetype)init{
    if (self = [super init]) {
        self.netConnectionReach = [Reachability reachabilityForInternetConnection];
        self.netConnectionReach.reachableBlock = ^(Reachability * reachability){
            
        };
        self.netConnectionReach.unreachableBlock = ^(Reachability * reachability){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD showError:@"网络似乎断开,请重试" toView:nil];
            });
        };
        [self.netConnectionReach startNotifier];
    }
    return self;
}
-(NetworkStatus)currentNetStatus{
    return [self.netConnectionReach currentReachabilityStatus];
}


@end
