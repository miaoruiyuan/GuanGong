//
//  GGAttestationCheckingView.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/5.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGAttestationCheckingView.h"

@interface GGAttestationCheckingView()

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *desLabel;

@end

@implementation GGAttestationCheckingView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void)showInAttestationController
{
    self.hidden = NO;
    self.titleLabel.text = @"实名认证审核中";
    self.desLabel.text = @"如需加急处理，请联系客服";
}

- (void)showInCompanyController
{
    self.hidden = NO;
    self.titleLabel.text = @"企业认证审核中";
    self.desLabel.text = @"如需加急处理，请联系客服";
}

#pragma mark - layoutView

- (void)setupView
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-120);
        make.size.mas_equalTo(CGSizeMake(190, 138));
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(30);
        make.left.right.equalTo(self);
    }];
    
    [self addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self);
    }];
    
    [self addSubview:self.phoneBtn];
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLabel.mas_bottom).offset(15);

        make.centerX.equalTo(self);
        make.width.mas_equalTo(186);
        make.height.mas_equalTo(32);
    }];
}

#pragma mark - initView
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Attestation_check_ing"]];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:14];
        _desLabel.textColor = textLightColor;
        _desLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _desLabel;
}

- (UIButton *)phoneBtn
{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"42b2f6"]] forState:UIControlStateNormal];
        _phoneBtn.layer.masksToBounds = YES;
        _phoneBtn.layer.cornerRadius = 4;
        [_phoneBtn setImage:[UIImage imageNamed:@"Attestation_check_phone_icon"] forState:UIControlStateNormal];
        [_phoneBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        [_phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_phoneBtn setTitle:@"400-822-0063" forState:UIControlStateNormal];
        _phoneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _phoneBtn;
}


@end
