//
//  GGAddBankCardRewardAlertView.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/13.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGAddBankCardRewardAlertView.h"

@interface GGAddBankCardRewardAlertView()
{

}

@property (nonatomic,copy) void(^block)(BOOL isCancel);

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIView *centerLineView;

@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *submitBtn;

@end

@implementation GGAddBankCardRewardAlertView

+ (instancetype)showWithContent:(NSString *)content confirmText:(NSString *)confirmText andBlock:(void(^)(BOOL isCancel))block
{
    GGAddBankCardRewardAlertView *alertView = [[GGAddBankCardRewardAlertView alloc] init];
    [alertView setupView];
    [alertView addButtonAction];
    [alertView showWithContent:content confirmText:confirmText andBlock:block];
    return alertView;
}

+ (instancetype)showCardWithContent:(NSString *)content onlyShowSubmitBtn:(NSString *)text andBlock:(void(^)(BOOL isCancel))block;
{
    GGAddBankCardRewardAlertView *alertView = [[GGAddBankCardRewardAlertView alloc] init];
    [alertView setupView];
    [alertView addButtonAction];
    [alertView showWithContent:content confirmText:text andBlock:block];
    alertView.imageView.image = [UIImage imageNamed:@"car_history_buy_add_bank_card_icon"];
    [alertView onlyShowSubmitBtn];
    return alertView;
}

+ (instancetype)showAuthenticateWithContent:(NSString *)content onlyShowSubmitBtn:(NSString *)text andBlock:(void(^)(BOOL isCancel))block
{
    GGAddBankCardRewardAlertView *alertView = [[GGAddBankCardRewardAlertView alloc] init];
    [alertView setupView];
    [alertView addButtonAction];
    [alertView showWithContent:content confirmText:text andBlock:block];
    alertView.imageView.image = [UIImage imageNamed:@"car_history_buy_add_realName"];
    [alertView onlyShowSubmitBtn];
    return alertView;
}

- (void)onlyShowSubmitBtn
{
    self.cancelBtn.hidden = YES;
    self.centerLineView.hidden = YES;
    [self.submitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_bottom).offset(-55);
        make.height.mas_equalTo(55);
    }];
}

- (void)showWithContent:(NSString *)content confirmText:(NSString *)confirmText andBlock:(void(^)(BOOL isCancel))block
{
    if (block) {
        self.block = block;
    }
    self.titleLabel.text = content;
    [self.submitBtn setTitle:confirmText forState:UIControlStateNormal];
    self.contentView.alpha = 0;
    [UIView animateWithDuration:0.2f animations:^{
        self.contentView.alpha = 1;
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

- (void)setupView
{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.frame = [[UIScreen mainScreen] bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    
    
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(20);
        make.size.mas_equalTo(CGSizeMake(147, 121));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.imageView.mas_bottom).offset(25);
    }];
    
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(55);
    }];
    
    [self.contentView addSubview:self.submitBtn];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.left.equalTo(self.contentView.mas_centerX);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(55);
    }];
}

- (void)addButtonAction
{
    [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.block){
            self.block(YES);
        }
        [self hiddenView];
    }];
    
    [[self.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.block){
            self.block(NO);
        }
        [self hiddenView];
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
        UIView *lineHView = [[UIView alloc] init];
        lineHView.backgroundColor = sectionColor;
        [_contentView addSubview:lineHView];
        [lineHView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentView);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(_contentView).offset(-55);
        }];
        
        UIView *lineVView = [[UIView alloc] init];
        lineVView.backgroundColor = sectionColor;
        self.centerLineView = lineVView;
        [_contentView addSubview:lineVView];
        [lineVView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentView.mas_bottom).offset(-55);
            make.bottom.equalTo(_contentView);
            make.centerX.equalTo(_contentView);
            make.width.mas_equalTo(0.5);
        }];
    }
    return  _contentView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"car_history_buy_add_bank_card_icon"]];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = textNormalColor;
        _titleLabel.numberOfLines = 0;
        _titleLabel.preferredMaxLayoutWidth = kScreenWidth - 90;
    }
    return _titleLabel;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:textLightColor forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _cancelBtn;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"去绑定" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:themeColor forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _submitBtn;
}

@end
