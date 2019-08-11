//
//  GGFooterView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFooterView.h"

@implementation GGFooterView

- (instancetype)initWithFrame:(CGRect)frame andFootButtonTitle:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        if (!_footerButton) {
            _footerButton  = [UIButton buttonWithType:UIButtonTypeCustom];
            _footerButton.frame = CGRectMake(12, (frame.size.height - 44)/2, frame.size.width - 24, 44);
            [_footerButton setTitle:title forState:UIControlStateNormal];
            [_footerButton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
            [_footerButton.titleLabel setFont:[UIFont systemFontOfSize:15.8]];
            _footerButton.layer.masksToBounds = YES;
            _footerButton.layer.cornerRadius = 4;
            [self addSubview:_footerButton];
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
