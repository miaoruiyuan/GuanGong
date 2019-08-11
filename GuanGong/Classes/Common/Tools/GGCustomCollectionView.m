//
//  GGCustomCollectionView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCustomCollectionView.h"

@implementation GGCustomCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    //当事件是传递给此View内部的子View时，让子View自己捕获事件，如果是传递给此View自己时，放弃事件捕获
    UIView* __tmpView = [super hitTest:point withEvent:event];
    if (__tmpView == self) {
        return nil;
    }
    return __tmpView;
}


@end
