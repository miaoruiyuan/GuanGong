//
//  GGNotificationManager.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface GGNotificationManager : NSObject

//+ (NSInteger)getPushMessagID:(NSDictionary *)pushInfo;

+ (void)uploadDeviceToken:(NSData *)deviceToken;

+ (void)handleNotificationInfo:(NSDictionary *)userInfo;

//+ (void)didReceiveNotificationResponse:(UNNotificationResponse *)response;

+ (void)updateUserInfo:(NSDictionary *)pushInfo;

@end
