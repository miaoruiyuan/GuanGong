//
//  GGCarOrderBottomView.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/12/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCarOrderDetail.h"


@protocol CarOrderDetailButtonViewDelegate <NSObject>

- (void)carOrderDetailButtonClicked:(UIButton *)sender;

@end

@interface GGCarOrderBottomView : UIView

@property(nonatomic,assign)BOOL isShow;

@property(nonatomic,assign)BOOL isRefund;

@property(nonatomic,strong)GGCarOrderDetail *orderDetail;

@property(nonatomic,weak)id<CarOrderDetailButtonViewDelegate> delegate;

@end
