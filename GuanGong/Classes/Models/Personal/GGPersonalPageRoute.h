//
//  GGPersonalPageRoute.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGFormItem.h"


@interface GGPersonalPageRoute : NSObject

+ (void)pushWithItem:(GGFormItem *)item nav:(UINavigationController *)nav callBack:(void(^)(id x))callBack;

+ (void)ShowActionSheet:(GGFormItem *)item formViewController:(UIViewController *)controller callBack:(void(^)(id x))callBack;

+ (void)presentImagePickerControllerWith:(GGFormItem *)item formViewController:(UIViewController *)controller callBack:(void(^)(id x))callBack;

@end
