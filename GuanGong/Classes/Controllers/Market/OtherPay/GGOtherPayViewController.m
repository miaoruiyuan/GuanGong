//
//  GGOtherPayViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOtherPayViewController.h"
#import "GGFriendApplyPageViewController.h"
#import "GGMineApplyPageViewController.h"

@interface GGOtherPayViewController ()

@property(nonatomic,strong)UISegmentedControl *segmentControl;
@property(nonatomic,strong)GGFriendApplyPageViewController *friendPageVC;
@property(nonatomic,strong)GGMineApplyPageViewController *minePageVC;
@property(nonatomic,strong)UIViewController *currentVC;

@end

@implementation GGOtherPayViewController

- (void)bindViewModel{
    
}

- (void)setupView{
    self.navigationItem.titleView = self.segmentControl;
    
    self.edgesForExtendedLayout = NO;
    [self.view addSubview:self.friendPageVC.view];
    self.currentVC = self.friendPageVC;
    
    
    @weakify(self);
    [[self.segmentControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *segmented) {
        @strongify(self);
        
        if (segmented.selectedSegmentIndex == 0) {
            [self replaceController:self.currentVC newController:self.friendPageVC];
            [MobClick event:@"friendsapplication"];
        }else{
            [self replaceController:self.currentVC newController:self.minePageVC];
            [MobClick event:@"myapplication"];
        }
    }];

    if (self.value) {
        [self bk_performBlock:^(id obj) {
            @strongify(self);
            self.segmentControl.selectedSegmentIndex = 1;
            [self replaceController:self.currentVC newController:self.minePageVC];
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



- (GGFriendApplyPageViewController *)friendPageVC{
    if (!_friendPageVC) {
        _friendPageVC = [[GGFriendApplyPageViewController alloc]init];
        [self addChildViewController:_friendPageVC];
    }
    return _friendPageVC;
}

- (GGMineApplyPageViewController *)minePageVC{
    if (!_minePageVC) {
        _minePageVC = [[GGMineApplyPageViewController alloc] init];
        [self addChildViewController:_minePageVC];
    }
    return _minePageVC;
}



- (UISegmentedControl *)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"朋友申请",@"我的申请"]];
        _segmentControl.frame = CGRectMake(0, 0, 140, 28);
        _segmentControl.tintColor = themeColor;
        _segmentControl.selectedSegmentIndex = 0;
        [_segmentControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.4 weight:UIFontWeightLight]} forState:UIControlStateNormal];
    }
    return _segmentControl;
}

@end
