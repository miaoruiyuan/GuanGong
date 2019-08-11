//
//  GGTwoButtonsView.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGOrderDetails.h"

@protocol ButtonViewDelegate <NSObject>

- (void)twoButtonClicked:(UIButton *)sender;

@end

@interface GGTwoButtonsView : UIView

@property(nonatomic,weak)id<ButtonViewDelegate> delegate;

- (instancetype)initWithBuyerDetailObj:(GGOrderDetails *)detail isRefundDetail:(BOOL)refundDetail;

- (instancetype)initWithSellerDetailObj:(GGOrderDetails *)detail isRefundDetail:(BOOL)refundDetail;


@end
