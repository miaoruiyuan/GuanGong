//
//  GGLocationViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 16/5/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBaseViewController.h"
#import "GGFormItem.h"
#import "GGLocationViewController.h"


@interface GGLocationViewController : GGBaseViewController

- (instancetype)initWithItem:(GGFormItem *)item;

@property(nonatomic,assign)BOOL isCarsList;

@end
