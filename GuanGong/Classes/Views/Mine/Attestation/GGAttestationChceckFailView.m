//
//  GGAttestationChceckFailView.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/5.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGAttestationChceckFailView.h"

@interface GGAttestationChceckFailView()

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *desLabel;

@end

@implementation GGAttestationChceckFailView

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
    self.titleLabel.text = @"审核未通过";
    self.desLabel.text = @"请修改信息后重新上传";
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

    [self addSubview:self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(45);
    }];
}

#pragma mark - initView
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Attestation_check_fail"]];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = themeColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"审核未通过";
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
        _desLabel.text = @"请修改信息后重新上传";
    }
    return _desLabel;
}

- (UIButton *)editBtn
{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        _editBtn.layer.masksToBounds = YES;
        _editBtn.layer.cornerRadius = 4;
        [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editBtn setTitle:@"立即修改" forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _editBtn;
}

@end
