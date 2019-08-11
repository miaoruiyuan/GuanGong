//
//  GGBaseViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/4/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBaseViewController.h"

@interface GGBaseViewController ()

@end

@implementation GGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self setupView];
    [self bindViewModel];
}

- (void)setupView{};

- (void)bindViewModel{};

- (void)viewWillDisappear:(BOOL)animated
{
    
//    DLog(@"%@ viewWillDisappear",NSStringFromClass(self.class));

    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] resignFirstResponder];
}


- (void)pushTo:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popTo:(Class)vc{
    for (UIViewController *childVC in self.navigationController.childViewControllers) {
        if ([childVC isKindOfClass:vc]) {
            [self.navigationController popToViewController:childVC animated:YES];
            return;
        }
    }
}

+ (void)presentVC:(UIViewController *)viewController{
    if (!viewController) {
        return;
    }
    GGNavigationController *nav = [[GGNavigationController alloc] initWithRootViewController:viewController];
    if (!viewController.navigationItem.leftBarButtonItem) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:viewController action:@selector(navigationCloseBtnClicked)];
    }
    [[self presentingVC] presentViewController:nav animated:YES completion:nil];
}

+ (UIViewController *)presentingVC
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

- (void)navigationCloseBtnClicked
{
    [self dismiss];
}

- (void)dismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"--------viewWillAppear----------\n%@\n",NSStringFromClass(self.class));
}

- (void)dealloc
{
    DLog(@"--------ViewController Dealloc----------\n%@\n",NSStringFromClass(self.class));
}

@end
