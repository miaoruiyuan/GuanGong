//
//  GGPaymentResultView.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/27.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPaymentCircleView.h"

@protocol GGPaymentResultViewDelegate <NSObject>

- (void)didTappedResultViewConfirmButton;
- (void)didTappedResultViewBackButton;

@end

@interface GGPaymentResultView : UIView

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet GGPaymentCircleView *loadView;

@property (nonatomic, weak) id<GGPaymentResultViewDelegate> delegate;

@end
