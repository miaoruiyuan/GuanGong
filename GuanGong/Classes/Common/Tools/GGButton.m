//
//  GGButton.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/20.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGButton.h"

@implementation GGButton
{
    GGButtonStyle _style;
}

- (instancetype)initWithButtonTitle:(NSString *)title style:(GGButtonStyle)style size:(CGFloat)size{
    if (self = [super init]) {
        _style = style;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:size];
        [self setTitle:title forState:UIControlStateNormal];
        self.backgroundColor = [UIColor clearColor];
        switch (style) {
            case GGButtonStyleNormal:break;
            case GGButtonStyleSolid: {
                [self solidBtn];
                break;
            }
            case GGButtonStyleHollowTag:{
                [self hollowTagBtn];
                break;
            }
            case GGButtonStyleHollow: {
                [self hollowBtn];
                break;
            }
            case GGButtonStyleText: {
                [self textBtn];
                break;
            }
            case GGButtonStyleUpDown:{
                [self textBtn];
                break;
            };
        }
        [self addTarget:self action:@selector(didTouchDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(didTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(didTouchUp:) forControlEvents:UIControlEventTouchDragExit];
    }
    return self;
}

- (instancetype)initWithButtonTitle:(NSString *)title style:(GGButtonStyle)style size:(CGFloat)size ico:(NSString *)ico highlighIco:(NSString *)highlighIco{
    self = [self initWithButtonTitle:title style:style size:size];
    [self setImage:[UIImage imageNamed:ico] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:highlighIco] forState:UIControlStateHighlighted];
    return self;
}

- (instancetype)initWithButtonTitle:(NSString *)title
                             style:(GGButtonStyle)style
                              size:(CGFloat)size
                     highlighImage:(UIColor *)highlighColor{
    
    self = [self initWithButtonTitle:title style:style size:size];
    [self setBackgroundImage:[UIImage imageWithColor:highlighColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    return self;
}

- (void)didTouchDown:(UIButton *)sender{
    self.alpha = 0.5;
}
- (void)didTouchUp:(UIButton *)sender{
    self.alpha = 1.0;
}
- (void)solidBtn{
    self.backgroundColor = themeColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
}
- (void)hollowTagBtn{
    self.userInteractionEnabled = NO;
    UIImage *image = [[UIImage imageNamed:@"image_tag"] stretchableImageWithLeftCapWidth:25 topCapHeight:10];
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}
- (void)hollowBtn{
    self.layer.borderColor = themeColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
    [self setTitleColor:themeColor forState:UIControlStateNormal];
}
-(void)textBtn{
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(CGSize)intrinsicContentSize{
    if (_style == GGButtonStyleHollowTag) {
        return CGSizeMake(self.titleLabel.intrinsicContentSize.width + 30, self.titleLabel.intrinsicContentSize.height + 6);
    }
    return [super intrinsicContentSize];
}
-(void)upateTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_style != GGButtonStyleUpDown) return;
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width / 2;
    center.y = self.imageView.frame.size.height / 2 + 5;
    self.imageView.center = center;
    
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + 10;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
