//
//  GGBusinessItemView.m
//  GuanGong
//
//  Created by CodingTom on 2017/2/15.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGBusinessItemView.h"
#import "FDStackView.h"

@interface GGBusinessItemView()
{
    
}

@property(nonatomic,strong)FDStackView *stackView;

@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UIButton *middleButton;
@property(nonatomic,strong)UIButton *rightButton;

@end

@implementation GGBusinessItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
}


- (FDStackView *)stackView
{
    if (!_stackView) {
        _stackView = [[FDStackView alloc] initWithArrangedSubviews:@[self.leftButton, self.middleButton, self.rightButton]];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.alignment = UIStackViewAlignmentFill;
    }
    return _stackView;
}

- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.tag = 10;
        _leftButton.showsTouchWhenHighlighted = YES;
        [_leftButton setImage:[UIImage imageNamed:@"business_car_manager"] forState:UIControlStateNormal];
        [_leftButton setTitle:@"车辆管理" forState:UIControlStateNormal];
        [_leftButton.titleLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular]];
        [_leftButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_leftButton centerImageAndTitle:18];
        [_leftButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)middleButton
{
    if (!_middleButton) {
        _middleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _middleButton.tag = 11;
        _middleButton.showsTouchWhenHighlighted = YES;
        [_middleButton setImage:[UIImage imageNamed:@"business_buycar_order"] forState:UIControlStateNormal];
        [_middleButton setTitle:@"买车订单" forState:UIControlStateNormal];
        [_middleButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_middleButton.titleLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular]];
        [_middleButton centerImageAndTitle:18];
        [_middleButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _middleButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.tag = 12;
        _rightButton.showsTouchWhenHighlighted = YES;
        [_rightButton setImage:[UIImage imageNamed:@"business_sellcar_order"] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_rightButton setTitle:@"卖车订单" forState:UIControlStateNormal];
        [_rightButton.titleLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular]];
        
        
        [_rightButton centerImageAndTitle:18];
        [_rightButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}


#pragma mark - Action
- (void)buttonClickAction:(UIButton *)sender
{
    if (self.click) {
        self.click(sender.tag - 10);
    }
}

@end
