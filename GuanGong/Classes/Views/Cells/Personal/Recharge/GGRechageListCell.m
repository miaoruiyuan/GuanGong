//
//  GGRechageListCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/7/18.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGRechageListCell.h"

NSString * const kGGRechageListCellID = @"GGRechageListCell";

@interface GGRechageListCell()
{
    
}

@property (nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *typeNameLabel;
@property(nonatomic,strong)UILabel *diffLabel;
@property(nonatomic,strong)UILabel *desLabel;
@property(nonatomic,strong)UILabel *poundageDesLabel;
@property(nonatomic,strong)UILabel *poundageLabel;

@end

@implementation GGRechageListCell

- (void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 3;
    
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(20);
        make.size.mas_equalTo(CGSizeMake(20, 17));
    }];
    
    [self.contentView addSubview:self.typeNameLabel];
    [self.typeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(13);
        make.top.equalTo(self.contentView).offset(20);
    }];
    
    
    [self.contentView addSubview:self.diffLabel];
    [self.diffLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeNameLabel);
        make.top.equalTo(self.typeNameLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(55, 18));
    }];
    
    [self.contentView addSubview:self.poundageLabel];
    [self.poundageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.typeNameLabel);
    }];
    
    [self.contentView addSubview:self.poundageDesLabel];
    [self.poundageDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.poundageLabel.mas_bottom).offset(10);
    }];
    
    [self.contentView addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeNameLabel);
        make.bottom.right.equalTo(self.contentView).offset(-20);
    }];
}

- (void)updateUIWithModel:(GGBankRechargeRateModel *)model;{
    self.poundageDesLabel.text = @"手续费";
    if (model) {
        self.iconImageView.image = [UIImage imageNamed:@"rechage_type_other"];
        self.typeNameLabel.text = @"银行卡充值";
        self.diffLabel.text = @"方便快捷";
       // self.poundageLabel.text = [NSString stringWithFormat:@"%.2f%%~%.2f%%",[model.debitRate doubleValue],[model.creditRate doubleValue]];
        self.poundageLabel.text = [NSString stringWithFormat:@"%.1f%%",model.debitRate];
        self.desLabel.text = model.chargeRateRemark;
    }else{
        self.iconImageView.image = [UIImage imageNamed:@"rechage_type_card"];
        self.typeNameLabel.text = @"其他方式充值";
        self.diffLabel.text = @"零手续费";
        self.poundageLabel.text = @"0%";
        self.desLabel.text = @"30分钟到账，当日提现";
    }
}

#pragma mark - init View

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)typeNameLabel
{
    if (!_typeNameLabel) {
        _typeNameLabel = [[UILabel alloc] init];
        _typeNameLabel.font = [UIFont boldSystemFontOfSize:16];
        _typeNameLabel.textColor = [UIColor blackColor];
    }
    return _typeNameLabel;
}

- (UILabel *)diffLabel
{
    if (!_diffLabel) {
        _diffLabel = [[UILabel alloc] init];
        _diffLabel.font = [UIFont systemFontOfSize:11];
        _diffLabel.textColor = [UIColor colorWithHexString:@"e54c4e"];
        _diffLabel.backgroundColor = [UIColor colorWithHexString:@"fceced"];
        _diffLabel.textAlignment = NSTextAlignmentCenter;
        _diffLabel.layer.masksToBounds = YES;
        _diffLabel.layer.cornerRadius = 2;
    }
    return _diffLabel;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:12];
        _desLabel.textAlignment = NSTextAlignmentRight;
        _desLabel.textColor = [UIColor colorWithHexString:@"8e8e8e"];
    }
    return _desLabel;
}


- (UILabel *)poundageDesLabel
{
    if (!_poundageDesLabel) {
        _poundageDesLabel = [[UILabel alloc] init];
        _poundageDesLabel.font = [UIFont systemFontOfSize:12];
        _poundageDesLabel.textColor = [UIColor colorWithHexString:@"8e8e8e"];
        _poundageDesLabel.textAlignment = NSTextAlignmentRight;
    }
    return _poundageDesLabel;
}

- (UILabel *)poundageLabel
{
    if (!_poundageLabel) {
        _poundageLabel = [[UILabel alloc] init];
        _poundageLabel.font = [UIFont boldSystemFontOfSize:16];
        _poundageLabel.textColor = [UIColor blackColor];
        _poundageLabel.textAlignment = NSTextAlignmentRight;
    }
    return _poundageLabel;
}

@end
