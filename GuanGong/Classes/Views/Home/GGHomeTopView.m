//
//  GGHomeTopView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/5/30.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGHomeTopView.h"
#import "UIButton+Common.h"
#import "NSString+Common.h"
#import "FDStackView.h"

@interface GGHomeTopView ()

@property(nonatomic,strong)FDStackView *stackView;

@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UIButton *middleButton;
@property(nonatomic,strong)UIButton *rightButton;


//@property(nonatomic,strong)UILabel *balanceLabel;


@end

@implementation GGHomeTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
    }
    return self;
}

- (void)setUpView
{
    self.backgroundColor = [UIColor whiteColor];
//    [UIColor colorWithHexString:@"#484848"];
    
//    [self addSubview:self.balanceLabel];
//    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self);
//        make.bottom.equalTo(self.mas_bottom).offset(-24);
//        make.height.mas_equalTo(14);
//    }];
    
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(20, 0, 14, 0));
    }];
    
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
////    _balanceLabel.text = [NSString stringWithFormat:@"￥%@",[NSString positiveFormat:[GGLogin shareUser].wallet.totalBalance.stringValue]];
//    
//}

//- (void)setWallet:(GGWallet *)wallet
//{
//    if (_wallet != wallet) {
//        _wallet = wallet;
//        _balanceLabel.text = [NSString stringWithFormat:@"￥%@",[NSString positiveFormat:_wallet.totalBalance.stringValue]];
//    }
//}


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
        _leftButton.tag = 9;
        _leftButton.showsTouchWhenHighlighted = YES;
        [_leftButton setImage:[UIImage imageNamed:@"home_transfer_accounts"] forState:UIControlStateNormal];
        [_leftButton setTitle:@"转账" forState:UIControlStateNormal];
        [_leftButton.titleLabel setFont:[UIFont systemFontOfSize:14.2 weight:UIFontWeightRegular]];
        [_leftButton setTitleColor:TextColor forState:UIControlStateNormal];
        [_leftButton centerImageAndTitle:18];
        [_leftButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)middleButton
{
    if (!_middleButton) {
        _middleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _middleButton.tag = 10;
        _middleButton.showsTouchWhenHighlighted = YES;
        [_middleButton setImage:[UIImage imageNamed:@"home_recharge"] forState:UIControlStateNormal];
        [_middleButton setTitle:@"余额" forState:UIControlStateNormal];
        [_middleButton setTitleColor:TextColor forState:UIControlStateNormal];
        [_middleButton.titleLabel setFont:[UIFont systemFontOfSize:14.2 weight:UIFontWeightRegular]];
        [_middleButton centerImageAndTitle:18];
        [_middleButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _middleButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.tag = 11;
        _rightButton.showsTouchWhenHighlighted = YES;
        [_rightButton setImage:[UIImage imageNamed:@"home_safePay"] forState:UIControlStateNormal];
        [_rightButton setTitleColor:TextColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"担保支付" forState:UIControlStateNormal];
        [_rightButton.titleLabel setFont:[UIFont systemFontOfSize:14.2 weight:UIFontWeightRegular]];
        
        
        [_rightButton centerImageAndTitle:18];
        [_rightButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}


//- (UILabel *)balanceLabel{
//    if (!_balanceLabel) {
//        _balanceLabel = [[UILabel alloc] init];
//        _balanceLabel.font = [UIFont systemFontOfSize:13.2];
//        _balanceLabel.textColor = TextColor;
//        _balanceLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _balanceLabel;
//}



#pragma mark - Action
- (void)buttonClickAction:(UIButton *)sender
{
    if (self.click) {
        self.click(sender.tag);
    }
}

@end
