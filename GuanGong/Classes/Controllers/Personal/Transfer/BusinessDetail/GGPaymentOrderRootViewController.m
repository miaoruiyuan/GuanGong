//
//  GGPaymentOrderRootViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/31.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGPaymentOrderRootViewController.h"
#import "GGPaymentOrderPageViewController.h"

@interface GGPaymentOrderRootViewController ()

@property(nonatomic,strong)UISegmentedControl *segmentControl;
@property(nonatomic,strong)GGPaymentOrderPageViewController *buyerPageVC;
@property(nonatomic,strong)GGPaymentOrderPageViewController *sellerPageVC;
@property(nonatomic,strong)UIViewController *currentVC;

@end

@implementation GGPaymentOrderRootViewController

- (void)bindViewModel{
    
}

- (void)setupView{
    self.navigationItem.titleView = self.segmentControl;
    
    self.edgesForExtendedLayout = NO;

    if (self.showSeller){
        self.segmentControl.selectedSegmentIndex = 1;
        [self.view addSubview:self.sellerPageVC.view];
        self.currentVC = self.sellerPageVC;
    }else{
        self.segmentControl.selectedSegmentIndex = 0;
        [self.view addSubview:self.buyerPageVC.view];
        self.currentVC = self.buyerPageVC;
    }

    
    @weakify(self);
    [[self.segmentControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *segmented) {
        @strongify(self);
        
        if (segmented.selectedSegmentIndex == 0) {
            [self replaceController:self.currentVC newController:self.buyerPageVC];
            [MobClick event:@"friendsapplication"];
        }else{
            [self replaceController:self.currentVC newController:self.sellerPageVC];
            [MobClick event:@"myapplication"];
        }
    }];
    
    if (self.value) {
        [self bk_performBlock:^(id obj) {
            @strongify(self);
            self.segmentControl.selectedSegmentIndex = 1;
            [self replaceController:self.currentVC newController:self.sellerPageVC];
        } afterDelay:.5];
    }
    
}

#pragma mark - 替换
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController{
    [self addChildViewController:newController];
    
    [self transitionFromViewController:oldController
                      toViewController:newController
                              duration:0.35
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{
                                
                            }
                            completion:^(BOOL finished) {
                                
                                if (finished) {
                                    [newController didMoveToParentViewController:self];
                                    [oldController willMoveToParentViewController:nil];
                                    [oldController removeFromParentViewController];
                                    self.currentVC = newController;
                                }else{
                                    self.currentVC = oldController;
                                }
                                
                            }];
}

- (GGPaymentOrderPageViewController *)buyerPageVC{
    if (!_buyerPageVC) {
        _buyerPageVC = [[GGPaymentOrderPageViewController alloc] initBuyerOrderViewController];
        [self addChildViewController:_buyerPageVC];
    }
    return _buyerPageVC;
}

- (GGPaymentOrderPageViewController *)sellerPageVC{
    if (!_sellerPageVC) {
        _sellerPageVC = [[GGPaymentOrderPageViewController alloc] initSellerOrderViewController];
        [self addChildViewController:_sellerPageVC];
    }
    return _sellerPageVC;
}

- (UISegmentedControl *)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"支出",@"收入"]];
        _segmentControl.frame = CGRectMake(0, 0, 140, 28);
        _segmentControl.tintColor = themeColor;
        _segmentControl.selectedSegmentIndex = 0;
        [_segmentControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.4 weight:UIFontWeightLight]} forState:UIControlStateNormal];
    }
    return _segmentControl;
}

@end

