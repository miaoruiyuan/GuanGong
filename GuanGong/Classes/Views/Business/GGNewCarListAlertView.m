//
//  GGNewCarListAlertView.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/10.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGNewCarListAlertView.h"

@interface GGNewCarListAlertView()

@property (nonatomic,copy) void(^block)();

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIImageView *titleLeftImageView;
@property (nonatomic,strong) UIImageView *titleRightImageView;

@property (nonatomic,strong) UIImageView *lineImageView;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) UIButton *cancelBtn;

@end

@implementation GGNewCarListAlertView

+ (NSString *)getDefaultContent
{
    return @"1、好车抢购交易为担保支付交易，买家确认收货后才会打款给卖家；\n\n2、支付订金后，请在规定时间内支付尾款，超过规定时间订单将自动关闭，且订金不予退回；\n\n3、好车抢购车辆不支持线上退货，如需退货 ，请在确认收货前与商家线下进行协商；\n\n4、下单即代表同意抢购规则。";
}


+ (instancetype)showContent:(NSString *)content andBlock:(void(^)())block
{
    GGNewCarListAlertView *alertView = [[GGNewCarListAlertView alloc] init];
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
    self.titleLabel.text = @"抢购规则";
    self.contentLabel.text = text;
    self.contentView.alpha = 0;
    self.cancelBtn.alpha = 0;
    [UIView animateWithDuration:0.2f animations:^{
        self.contentView.alpha = 1;
        self.cancelBtn.alpha = 1;
    }];
}

- (void)setupView
{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.frame = [[UIScreen mainScreen] bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-50);
        make.left.equalTo(self).offset(22);
        make.right.equalTo(self).offset(-22);
    }];

    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(24);
    }];
    
    [self.contentView addSubview:self.titleLeftImageView];
    [self.titleLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel.mas_left).offset(-10);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(11, 11));
    }];
    
    [self.contentView addSubview:self.titleRightImageView];
    [self.titleRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(11, 11));
    }];
    
    [self.contentView addSubview:self.lineImageView];
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(30);
        make.right.equalTo(self.contentView).offset(-30);
        make.top.equalTo(self.contentView).offset(65);
        make.height.mas_equalTo(1);
    }];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(30);
        make.right.equalTo(self.contentView).offset(-30);
        make.top.equalTo(self.lineImageView.mas_bottom).offset(30);
        make.bottom.equalTo(self.contentView).offset(-50);
    }];
    
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom).offset(20);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
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
    return _contentView;
}


- (UIImageView *)lineImageView
{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buy_new_car_tip_line"]];
    }
    return _lineImageView;
}

- (UIImageView *)titleLeftImageView
{
    if (!_titleLeftImageView) {
        _titleLeftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buy_new_car_alert_title_star_icon"]];
    }
    return _titleLeftImageView;
}
- (UIImageView *)titleRightImageView
{
    if (!_titleRightImageView) {
        _titleRightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buy_new_car_alert_title_star_icon"]];
    }
    return _titleRightImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = themeColor;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor colorWithHexString:@"4b4b4b"];
    }
    return _contentLabel;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setImage:[UIImage imageNamed:@"btn_buy_new_car_closeAlert_n"] forState:UIControlStateNormal];
    }
    return _cancelBtn;
}

@end
