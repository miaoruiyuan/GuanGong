//
//  GGAttestationNoCheckedView.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/5.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGAttestationNoCheckedView.h"

@interface GGAttestationNoCheckedView()

@property (nonatomic,strong)UIView *headerTipView;

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *desLabel;

@end

@implementation GGAttestationNoCheckedView

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

- (void)showInCompanyController
{
    self.hidden = NO;
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
    
    [self addSubview:self.checkBtn];
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(45);
    }];
    
    
    [self addSubview:self.headerTipView];
    [self.headerTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_equalTo(12);
        make.right.equalTo(self).mas_equalTo(-12);
        make.top.equalTo(self).offset(12);
        make.height.mas_equalTo(35);
    }];
}

#pragma mark - initView
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Attestation_no_check"]];
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
        _titleLabel.text = @"您还没有实名认证";
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
        _desLabel.text = @"实名认证通过后你才可以使用此功能";
    }
    return _desLabel;
}

- (UIButton *)checkBtn
{
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        _checkBtn.layer.masksToBounds = YES;
        _checkBtn.layer.cornerRadius = 4;
        [_checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_checkBtn setTitle:@"立即实名认证" forState:UIControlStateNormal];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _checkBtn;
}

- (UIView *)headerTipView
{
    if (!_headerTipView) {
        _headerTipView = [[UIView alloc] init];
        
        _headerTipView.backgroundColor = [UIColor colorWithHexString:@"ffeeee"];
        _headerTipView.layer.masksToBounds = YES;
        _headerTipView.layer.cornerRadius = 3;
        _headerTipView.layer.borderWidth = 0.5f;
        _headerTipView.layer.borderColor = [UIColor colorWithHexString:@"e54c4e"].CGColor;
        
        UILabel *desLabel = [[UILabel alloc] init];
//        desLabel.text = @"通过认证即可获得2次维保查询和10次VIN查询！";
        desLabel.numberOfLines = 0;
        desLabel.font = [UIFont systemFontOfSize:13];
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:@"通过认证即可获得2次维保查询和10次VIN查询！"];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:themeColor range:NSMakeRange(8,1)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:themeColor  range:NSMakeRange(15,2)];
        desLabel.attributedText = attributedStr;
        
        [_headerTipView addSubview:desLabel];
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerTipView).offset(10);
            make.centerY.equalTo(_headerTipView).offset(1);
        }];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Small_speakers_icon"]];
        [_headerTipView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(desLabel.mas_left).offset(-4);
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.centerY.equalTo(_headerTipView).offset(1);
        }];
    }
    return _headerTipView;
}

@end
