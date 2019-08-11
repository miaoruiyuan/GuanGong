//
//  NSObject+Common.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)

- (BOOL)checkRealNameAuthentication;

//- (void)showAlertToRealNameAuthentionAction:(void (^)(void))confrimAction inViewController:(UIViewController *)controller;

+ (BOOL)showError:(NSError *)error;
+ (NSString *)tipFromError:(NSError *)error;

+ (void)showStatusBarQueryStr:(NSString *)tipStr;
+ (void)showStatusBarSuccessStr:(NSString *)tipStr;
+ (void)showStatusBarErrorStr:(NSString *)errorStr;
+ (void)showStatusBarError:(NSError *)error;
+ (void)showHudTipStr:(NSString *)tipStr;


+ (BOOL)saveImage:(UIImage *)image imageName:(NSString *)imageName inFolder:(NSString *)folderName;
+ (NSData *)loadImageDataWithName:( NSString *)imageName inFolder:(NSString *)folderName;
+ (BOOL)deleteImageCacheInFolder:(NSString *)folderName;

-(id)handleResponse:(id)responseJSON;

@end
