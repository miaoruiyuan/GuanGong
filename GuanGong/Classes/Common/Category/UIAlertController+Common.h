//
//  UIAlertController+Common.h
//  GuanGong
//
//  Created by 苗芮源 on 16/5/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface UIAlertController (Common)

+(void)actionSheetInController:(UIViewController *)controller title:(NSString *)title message:(NSString *)message confrimBtn:(NSArray *)confrimBtns confrimStyle:(UIAlertActionStyle)confrimStyle confrimAction:(void (^)(UIAlertAction *action, NSInteger index))confrimAction cancelBtn:(NSString *)cancelBtn cancelStyle:(UIAlertActionStyle)cancelStyle cancelAction:(void (^)(void))cancelAction;

+(void)alertInController:(UIViewController *)controller title:(NSString *)title message:(NSString *)message confrimBtn:(NSString *)confrimBtn confrimStyle:(UIAlertActionStyle)confrimStyle confrimAction:(void(^)(void))confrimAction cancelBtn:(NSString *)cancelBtn cancelStyle:(UIAlertActionStyle)cancelStyle cancelAction:(void(^)(void))cancelAction;

+(void)textFiledAlertInController:(UIViewController *)controller
                            title:(NSString *)title
                          message:(NSString *)message
                       confrimBtn:(NSString *)confrimBtn
                     confrimStyle:(UIAlertActionStyle)confrimStyle
                    confrimAction:(void (^)(void))confrimAction
                        cancelBtn:(NSString *)cancelBtn
                      cancelStyle:(UIAlertActionStyle)cancelStyle
                     cancelAction:(void (^)(void))cancelAction
                        textFiled:(void(^)(UITextField *filed))field;


@end
