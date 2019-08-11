//
//  GGAddressPageRoute.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGFormItem.h"

@interface GGAddressPageRoute : NSObject

+ (void)pushWithItem:(GGFormItem *)item nav:(UINavigationController *)nav callBack:(void(^)(id x))callBack;

@end
