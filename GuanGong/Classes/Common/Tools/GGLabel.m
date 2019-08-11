//
//  GGLabel.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGLabel.h"

@implementation GGLabel

- (instancetype)init{
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
