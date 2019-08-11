//
//  GGOrderDepositAlertView.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/8.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGOrderDepositAlertView.h"

@interface GGOrderDepositAlertView()
{
    
}

@property (nonatomic,copy) void(^block)();

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *cancelBtn;

@end

@implementation GGOrderDepositAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)showContent:(NSString *)content andBlock:(void(^)())block
{
    GGOrderDepositAlertView *alertView = [[GGOrderDepositAlertView alloc] init];
    [alertView setupView];
    [alertView addButtonAction];
    [alertView showText:content andBlock:block];
    return alertView;
}

- (void)showText:(NSString *)text andBlock:(void(^)())block
{
    if (block) {
        self.block = block;
    }
    self.titleLabel.text = text;
    self.contentView.alpha = 0;
    [UIView animateWithDuration:0.2f animations:^{
        self.contentView.alpha = 1;
    }];
}

- (void)setupView
{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.frame = [[UIScreen mainScreen] bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(230, 110));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.left.equalTo(self.contentView).offset(30);
    }];
    
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)addButtonAction
{
    [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        if (self.block){
            self.block();
        }
        [self hiddenView];
    }];
}

- (void)hiddenView
{
    [UIView animateWithDuration:0.2f animations:^{
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - init view

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 3;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.userInteractionEnabled = YES;
    }
    return  _contentView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = textNormalColor;
        _titleLabel.numberOfLines = 0;
        _titleLabel.preferredMaxLayoutWidth = 170;
    }
    return _titleLabel;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setImage:[UIImage imageNamed:@"close_x"] forState:UIControlStateNormal];
//        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [_cancelBtn setTitleColor:textLightColor forState:UIControlStateNormal];
//        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _cancelBtn;
}

@end
