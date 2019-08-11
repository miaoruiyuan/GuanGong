//
//  AppUpdateRequest.h
//  GuanGong
//
//  Created by CodingTom on 2017/3/8.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface AppUpdateRequest : NSObject

+ (void)checkAppUpdateAuto;

+ (void)RefreshAppUpdateData:(void(^)(BOOL show))block;

@end
