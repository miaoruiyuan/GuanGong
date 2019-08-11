//
//  GGCreatCarPageRoute.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/27.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCreateCarPageRoute.h"
#import "ActionSheetMultipleStringPicker.h"
#import "GGCreateCarViewController.h"
#import "GGInputViewController.h"
#import "GGVinRecognitionViewController.h"
#import "GGCarModelViewController.h"
#import "GGModelListViewController.h"
#import "GGCarAddressViewController.h"
#import "GGDatePicker.h"

@implementation GGCreateCarPageRoute

+ (void)pushWithItem:(GGFormItem *)item nav:(UINavigationController *)nav callBack:(void(^)(id x))callBack{
    
    if ([item isPicker]) {
        GGDatePicker *picker = item.pageContent;
        
        ActionSheetMultipleStringPicker *sheetPicker = [[ActionSheetMultipleStringPicker alloc] initWithTitle:item.title rows:picker.value initialSelection:picker.defaultValue doneBlock:^(ActionSheetMultipleStringPicker *picker, NSArray *selectedIndexes, id selectedValues) {
            item.obj = [selectedValues componentsJoinedByString:@"-"];
            callBack(item);
        } cancelBlock:^(ActionSheetMultipleStringPicker *picker) {
            picker = nil;
        } origin:nav.topViewController.view];
        
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame = CGRectMake(0, 0, 40, 28);
        [doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doneButton.titleLabel setFont:[UIFont systemFontOfSize:11 weight:UIFontWeightMedium]];
        [doneButton.layer setMasksToBounds:YES];
        [doneButton.layer setCornerRadius:4.0];
        [doneButton.layer setBorderWidth:.7];
        [doneButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [sheetPicker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, 40, 28);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:11 weight:UIFontWeightMedium]];
        [cancelButton.layer setMasksToBounds:YES];
        [cancelButton.layer setCornerRadius:4.0];
        [cancelButton.layer setBorderWidth:.7];
        [cancelButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [sheetPicker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
        [sheetPicker showActionSheetPicker];
        
    } else {
        
        GGBaseViewController *viewController = nil;
        
        if (item.pageType == GGPageTypeInput) {
            if ([item.propertyName isEqualToString:@"price"]){
                if (item.obj && [item.obj isKindOfClass:[NSString class]]) {
                   item.obj = [item.obj stringByReplacingOccurrencesOfString:@"万元" withString:@""];
                }
            }
            if ([item.propertyName isEqualToString:@"reservePrice"]){
                if (item.obj && [item.obj isKindOfClass:[NSString class]]) {
                    item.obj = [item.obj stringByReplacingOccurrencesOfString:@"元" withString:@""];
                }
            }
            if ([item.propertyName isEqualToString:@"km"]){
                if (item.obj && [item.obj isKindOfClass:[NSString class]]) {
                    item.obj = [item.obj stringByReplacingOccurrencesOfString:@"万公里" withString:@""];
                }
            }
            viewController = [[GGInputViewController alloc] initWithItem:item];
        }

        //vin
        if (item.pageType == GGPageTypeVinRecognition) {
            viewController = [[GGVinRecognitionViewController alloc]initWithItem:item];
        }
        
        //车型
        if (item.pageType == GGPageTypeCarModel) {
            if ([(NSArray *)item.pageContent count] > 0) {
                viewController = [[GGModelListViewController alloc] initWithItem:item];
                viewController.popHandler = callBack;
                if ([nav.topViewController isKindOfClass:[GGCreateCarViewController class]]) {
                    [GGCreateCarViewController presentVC:viewController];
                }
                return;
            }
            viewController = [[GGCarModelViewController alloc] initWithItem:item];
        }
        
        if (item.pageType == GGPageTypeManagerAddress) {
            viewController = [[GGCarAddressViewController alloc] initWithItem:item];
        }
        
        [nav pushViewController:viewController animated:YES];
        viewController.popHandler = callBack;
    }
}

@end
