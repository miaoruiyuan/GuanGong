//
//  GGCarModelViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBaseViewController.h"
#import "GGFormItem.h"

@interface GGCarModelViewController : GGBaseViewController

- (instancetype)initWithItem:(GGFormItem *)item;

@property(nonatomic,assign)BOOL isCarsList;

@end
