//
//  GGOrderDetailRootViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOrderDetailRootViewController.h"
#import "GGOrderDetailsViewController.h"
#import "GGRefundDetailsViewController.h"

@interface GGOrderDetailRootViewController ()

@property(nonatomic,strong)UISegmentedControl *segmentControl;
@property(nonatomic,strong)GGOrderDetailsViewController *orderDetailsVC;
@property(nonatomic,strong)GGRefundDetailsViewController *refunfDetailsVC;
@property(nonatomic,strong)UIViewController *currentVC;


@property(nonatomic,strong)GGOrderList *orderList;

@end

@implementation GGOrderDetailRootViewController


- (instancetype)initWithObject:(GGOrderList *)obj{
    if (self = [super init]) {
        self.orderList = obj;
        
    }
    return self;
}


- (void)setupView{
    self.edgesForExtendedLayout = NO;
    
    [self.view addSubview:self.orderDetailsVC.view];
    self.currentVC = self.orderDetailsVC;

    @weakify(self);
    [[self.segmentControl rac_signalForControlEvents:UIControlEventValueChanged]subscribeNext:^(UISegmentedControl *x) {
        @strongify(self);
        
        [self replaceController:self.currentVC newController:x.selectedSegmentIndex == 0 ? self.orderDetailsVC : self.refunfDetailsVC];
    }];
    
}

- (void)bindViewModel{

    switch (_orderList.statusId) {
            
        case OrderStatusTypeFWK:{
            if (_orderList.hasApplyReturn) {
                self.navigationItem.titleView = self.segmentControl;
            }else{
                self.navigationItem.title = @"订单详情";
            }
        }
            break;
            
        case OrderStatusTypeJYCG:{
            if (_orderList.hasApplyReturn) {
                self.navigationItem.titleView = self.segmentControl;
            }else{
                self.navigationItem.title = @"订单详情";
            }
        }
            break;
            
        case OrderStatusTypeSQTK:{
           self.navigationItem.titleView = self.segmentControl;
        }
            break;
            
        case OrderStatusTypeTKCG:{
            self.navigationItem.titleView = self.segmentControl;
        }
            break;

        case OrderStatusTypeJJTK:{
            self.navigationItem.titleView = self.segmentControl;
        }
            break;
            
        case OrderStatusTypeTYTK:{
            self.navigationItem.titleView = self.segmentControl;
        }
            break;

        case OrderStatusTypeZDJJTK:{
            self.navigationItem.titleView = self.segmentControl;
        }
            break;
            
        case OrderStatusTypeTHTK:{
            self.navigationItem.titleView = self.segmentControl;
        }
            break;

        case OrderStatusTypeTYTHTK:{
            self.navigationItem.titleView = self.segmentControl;
        }
            break;
            
        case OrderStatusTypeJJTHTK:{
            self.navigationItem.titleView = self.segmentControl;
        }
            break;
            
        case OrderStatusTypeMJSHTK:{
            self.navigationItem.titleView = self.segmentControl;
        }
            break;

        default:{
            self.navigationItem.title = @"订单详情";
        }
            break;
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



- (GGOrderDetailsViewController *)orderDetailsVC{
    if (!_orderDetailsVC) {
        _orderDetailsVC = [[GGOrderDetailsViewController alloc] initWithObject:self.orderList];
         [self addChildViewController:_orderDetailsVC];
    }
    return _orderDetailsVC;
}

- (GGRefundDetailsViewController *)refunfDetailsVC{
    if (!_refunfDetailsVC) {
        _refunfDetailsVC = [[GGRefundDetailsViewController alloc] initWithObject:self.orderList];
        [self addChildViewController:_refunfDetailsVC];
    }
    return _refunfDetailsVC;
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
