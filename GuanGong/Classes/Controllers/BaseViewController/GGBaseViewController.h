//
//  GGBaseViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 16/4/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGBaseViewController : UIViewController

//用于向前传值
@property(nonatomic,strong)id value;
//用于向后传值
@property(nonatomic,copy)void (^popHandler)(id);

- (void)setupView;
- (void)bindViewModel;

- (void)pushTo:(UIViewController *)vc;
- (void)pop;
- (void)popTo:(Class)vc;

+ (void)presentVC:(UIViewController *)viewControll;
- (void)dismiss;

@end
