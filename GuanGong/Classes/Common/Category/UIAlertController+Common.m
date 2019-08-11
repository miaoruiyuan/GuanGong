//
//  UIAlertController+Common.m
//  GuanGong
//
//  Created by 苗芮源 on 16/5/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "UIAlertController+Common.h"

@implementation UIAlertController (Common)

+(void)actionSheetInController:(UIViewController *)controller title:(NSString *)title message:(NSString *)message confrimBtn:(NSArray *)confrimBtns confrimStyle:(UIAlertActionStyle)confrimStyle confrimAction:(void (^)(UIAlertAction *action, NSInteger index))confrimAction cancelBtn:(NSString *)cancelBtn cancelStyle:(UIAlertActionStyle)cancelStyle cancelAction:(void (^)(void))cancelAction{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < confrimBtns.count; i ++) {
        [alert addAction:[UIAlertAction actionWithTitle:confrimBtns[i] style:confrimStyle handler:^(UIAlertAction * _Nonnull action) {
            if (confrimAction) confrimAction(action,i);
        }]];
    }
    
    if (cancelBtn) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelBtn style:cancelStyle handler:^(UIAlertAction * _Nonnull action) {
            if (cancelAction) cancelAction();
        }]];
    }
    [controller presentViewController:alert animated:YES completion:nil];
}

+(void)alertInController:(UIViewController *)controller title:(NSString *)title message:(NSString *)message confrimBtn:(NSString *)confrimBtn confrimStyle:(UIAlertActionStyle)confrimStyle confrimAction:(void (^)(void))confrimAction cancelBtn:(NSString *)cancelBtn cancelStyle:(UIAlertActionStyle)cancelStyle cancelAction:(void (^)(void))cancelAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (confrimBtn) {
        [alert addAction:[UIAlertAction actionWithTitle:confrimBtn style:confrimStyle handler:^(UIAlertAction * _Nonnull action) {
            if (confrimAction) confrimAction();
        }]];
    }
    if (cancelBtn) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelBtn style:cancelStyle handler:^(UIAlertAction * _Nonnull action) {
            if (cancelAction) cancelAction();
        }]];
    }
    [controller presentViewController:alert animated:YES completion:nil];
}

+(void)textFiledAlertInController:(UIViewController *)controller
                            title:(NSString *)title
                          message:(NSString *)message
                       confrimBtn:(NSString *)confrimBtn
                     confrimStyle:(UIAlertActionStyle)confrimStyle
                    confrimAction:(void (^)(void))confrimAction
                        cancelBtn:(NSString *)cancelBtn
                      cancelStyle:(UIAlertActionStyle)cancelStyle
                     cancelAction:(void (^)(void))cancelAction
                        textFiled:(void(^)(UITextField *filed))field{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        if (field) {
            field(textField);
        }
    }];
    
    if (confrimBtn) {
        [alert addAction:[UIAlertAction actionWithTitle:confrimBtn style:confrimStyle handler:^(UIAlertAction * _Nonnull action) {
            if (confrimAction) confrimAction();
        }]];
    }
    if (cancelBtn) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelBtn style:cancelStyle handler:^(UIAlertAction * _Nonnull action) {
            if (cancelAction) cancelAction();
        }]];
    }
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
