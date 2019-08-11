//
//  GGCarOrderDetailRootViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/12/9.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarOrderDetailRootViewController.h"
#import "GGCarOrderDetailViewController.h"
#import "GGCarRefundDetailViewController.h"

@interface GGCarOrderDetailRootViewController ()

@property(nonatomic,strong)UISegmentedControl *segmentControl;
@property(nonatomic,strong)GGCarOrderDetailViewController *carOrderVC;
@property(nonatomic,strong)GGCarRefundDetailViewController *carRefunfVC;
@property(nonatomic,strong)UIViewController *currentVC;

@end

@implementation GGCarOrderDetailRootViewController

- (void)setupView{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.carOrderVC.view];
    self.currentVC = self.carOrderVC;
}

- (void)bindViewModel{
    
    @weakify(self);
    [[self.segmentControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *x) {
        @strongify(self);
        [self replaceController:self.currentVC newController:x.selectedSegmentIndex == 0 ? self.carOrderVC : self.carRefunfVC];
    }];

    switch (_orderDetail.status) {
        case CarOrderStatusCJDD:
        case CarOrderStatusZFDJ:
        case CarOrderStatusYFH:
        case CarOrderStatusJYWC:
        case CarOrderStatusDDGB:
        self.navigationItem.title  = @"订单详情";
        break;
        
        case CarOrderStatusSQTK:
        case CarOrderStatusSQTH:
        case CarOrderStatusJJTK:
        case CarOrderStatusJJTH:
        case CarOrderStatusTYTK:
        case CarOrderStatusTYTH:
        self.navigationItem.titleView = self.segmentControl;
        break;
        
        default:
        break;
    }
}

- (void)reloadOrderData
{
    for (UIViewController *vc in self.childViewControllers) {
        [vc didMoveToParentViewController:self];
        [vc removeFromParentViewController];
    }
    self.carOrderVC = nil;
    self.carRefunfVC = nil;
    self.currentVC = self.carOrderVC;
    [self.view addSubview:self.carOrderVC.view];
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

- (GGCarOrderDetailViewController *)carOrderVC{
    if (!_carOrderVC) {
        _carOrderVC = [[GGCarOrderDetailViewController alloc] initWithObject:self.orderDetail];
        _carOrderVC.popHandler = self.popHandler;
        [self addChildViewController:_carOrderVC];
    }
    return _carOrderVC;
}

- (GGCarRefundDetailViewController *)carRefunfVC{
    if (!_carRefunfVC) {
        _carRefunfVC = [[GGCarRefundDetailViewController alloc] initWithObject:self.orderDetail];
        [self addChildViewController:_carRefunfVC];
    }
    return _carRefunfVC;
}

- (UISegmentedControl *)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"订单详情",@"退款详情"]];
        _segmentControl.frame = CGRectMake(0, 0, 140, 28);
        _segmentControl.tintColor = themeColor;
        _segmentControl.selectedSegmentIndex = 0;
    }
    return _segmentControl;
}

@end
