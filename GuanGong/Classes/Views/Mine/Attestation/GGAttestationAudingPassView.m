//
//  GGAttestationCheckedSuccessView.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/5.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGAttestationAudingPassView.h"

@interface GGAttestationAudingPassView()
{
}

@property (nonatomic,strong)UIImageView *headerBgImageView;
@property (nonatomic,strong)UILabel *successTitleLabel;

@property (nonatomic,strong)UILabel *nameTitleLabel;
@property (nonatomic,strong)UILabel *nameContentLabel;
@property (nonatomic,strong)UIView *line1View;


@property (nonatomic,strong)UILabel *cardTitleLabel;
@property (nonatomic,strong)UILabel *cardContentLabel;
@property (nonatomic,strong)UIView *line2View;


@end

@implementation GGAttestationAudingPassView

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
    self.headerBgImageView.image = [UIImage imageNamed:@"Attestation_person_auding_pass"];
    
    self.nameContentLabel.text = self.name;
    self.cardContentLabel.text = self.iDCard;

    self.nameTitleLabel.text = @"真实姓名";
    self.cardTitleLabel.text = @"身份证号";
    
    self.successTitleLabel.hidden = YES;
    self.cardTitleLabel.hidden = NO;
    self.cardContentLabel.hidden = NO;
    self.line2View.hidden = NO;
    
    self.hidden = NO;
}

- (void)showInCompanyController
{
    self.headerBgImageView.image = [UIImage imageNamed:@"Attestation_company_pass_bg"];
    self.nameContentLabel.text = self.name;
    
    self.nameTitleLabel.text = @"企业名称";
    self.successTitleLabel.hidden = NO;
    self.hidden = NO;
}

- (void)setupView
{
    self.backgroundColor = [UIColor whiteColor];

    [self addSubview:self.headerBgImageView];
    
    [self.headerBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self.headerBgImageView addSubview:self.successTitleLabel];
    [self.successTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerBgImageView);
        make.centerY.equalTo(self.headerBgImageView).offset(50);
        make.left.right.equalTo(self.headerBgImageView);
    }];
    
    [self addSubview:self.nameTitleLabel];
    [self.nameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(16);
        make.top.equalTo(self.headerBgImageView.mas_bottom).offset(14);
    }];
    
    [self addSubview:self.nameContentLabel];
    [self.nameContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(16);
        make.top.equalTo(self.headerBgImageView.mas_bottom).offset(14);
    }];
    
    [self addSubview:self.line1View];
    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerBgImageView.mas_bottom).mas_offset(44);
        make.left.equalTo(self.nameTitleLabel);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [self addSubview:self.cardTitleLabel];
    [self.cardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(16);
        make.top.equalTo(self.line1View.mas_bottom).offset(14);
    }];
    
    [self addSubview:self.cardContentLabel];
    [self.cardContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(16);
        make.top.equalTo(self.line1View.mas_bottom).offset(14);
    }];
    
    [self addSubview:self.line2View];
    [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1View.mas_bottom).mas_offset(44);
        make.left.equalTo(self.nameTitleLabel);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark -  initView

- (UIImageView *)headerBgImageView
{
    if (!_headerBgImageView){
        _headerBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Attestation_person_auding_pass"]];
        _headerBgImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _headerBgImageView;
}

- (UILabel *)successTitleLabel
{
    if (!_successTitleLabel) {
        _successTitleLabel = [[UILabel alloc] init];
        _successTitleLabel.font = [UIFont boldSystemFontOfSize:15];
        _successTitleLabel.textColor = [UIColor whiteColor];
        _successTitleLabel.textAlignment = NSTextAlignmentCenter;
        _successTitleLabel.text = @"您已通过企业认证";
    }
    return _successTitleLabel;
}

- (UILabel *)nameTitleLabel
{
    if (!_nameTitleLabel) {
        _nameTitleLabel = [[UILabel alloc] init];
        _nameTitleLabel.font = [UIFont systemFontOfSize:14];
        _nameTitleLabel.textColor = [UIColor colorWithHexString:@"737373"];
    }
    return _nameTitleLabel;
}

- (UILabel *)nameContentLabel
{
    if (!_nameContentLabel) {
        _nameContentLabel = [[UILabel alloc] init];
        _nameContentLabel.font = [UIFont systemFontOfSize:14];
        _nameContentLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _nameContentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nameContentLabel;
}

- (UIView *)line1View
{
    if (!_line1View) {
        _line1View = [[UIView alloc] init];
        _line1View.backgroundColor = sectionColor;
    }
    return _line1View;
}

- (UILabel *)cardTitleLabel
{
    if (!_cardTitleLabel) {
        _cardTitleLabel = [[UILabel alloc] init];
        _cardTitleLabel.font = [UIFont systemFontOfSize:14];
        _cardTitleLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _cardTitleLabel.hidden = YES;
    }
    return _cardTitleLabel;
}

- (UILabel *)cardContentLabel
{
    if (!_cardContentLabel) {
        _cardContentLabel = [[UILabel alloc] init];
        _cardContentLabel.font = [UIFont systemFontOfSize:14];
        _cardContentLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _cardContentLabel.textAlignment = NSTextAlignmentRight;
        _cardContentLabel.hidden = YES;
    }
    return _cardContentLabel;
}

- (UIView *)line2View
{
    if (!_line2View) {
        _line2View = [[UIView alloc] init];
        _line2View.backgroundColor = sectionColor;
        _line2View.hidden = YES;
    }
    return _line2View;
}

@end
