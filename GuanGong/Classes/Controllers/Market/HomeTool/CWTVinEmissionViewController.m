//
//  CWTEmissionStandardViewController.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/3/29.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTVinEmissionViewController.h"

@interface CWTVinEmissionViewController ()

@property(nonatomic,strong)UIImageView *cardView;
@property(nonatomic,strong)UILabel *emissionTitleLabel;
@property(nonatomic,strong)UILabel *emissionValueLabel;
@property(nonatomic,strong)UIImageView *imaginaryLineView;

@property(nonatomic,strong)UILabel *carNameLabel;
@property(nonatomic,strong)UILabel *vinLabel;
@property(nonatomic,strong)UILabel *dateLabel;

@end

@implementation CWTVinEmissionViewController

- (void)setupView{

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"查询结果";
    
    [self.view addSubview:self.cardView];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
    }];
    
    [self.cardView addSubview:self.emissionTitleLabel];
    [self.emissionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView.mas_top).offset(42);
        make.left.equalTo(self.cardView.mas_left).offset(32);
        make.height.mas_equalTo(27);
    }];
    
    [self.cardView addSubview:self.emissionValueLabel];
    [self.emissionValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.emissionTitleLabel.mas_right).offset(10);
        make.centerY.height.equalTo(self.emissionTitleLabel);
    }];
    
    [self.cardView addSubview:self.imaginaryLineView];
    [self.imaginaryLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView.mas_left).offset(32);
        make.right.equalTo(self.cardView.mas_right).offset(-32);
        make.top.equalTo(self.emissionTitleLabel.mas_bottom).offset(30);
        make.height.mas_equalTo(1);
    }];
    
    [self.cardView addSubview:self.carNameLabel];
    [self.carNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.imaginaryLineView);
        make.top.equalTo(self.imaginaryLineView.mas_bottom).offset(20);
    }];
    
    [self.cardView addSubview:self.vinLabel];
    [self.vinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.carNameLabel);
        make.top.equalTo(self.carNameLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.cardView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vinLabel);
        make.top.equalTo(self.vinLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(16);
        make.bottom.equalTo(self.cardView.mas_bottom).offset(-40);
    }];
}

- (void)setVinResult:(CWTVinResult *)vinResult{
    _vinResult = vinResult;
    self.emissionValueLabel.text = _vinResult.fdjh ? : @"暂无";
    self.carNameLabel.text = _vinResult.trimName;
    self.vinLabel.text = [NSString stringWithFormat:@"VIN: %@",_vinResult.vin];
    self.dateLabel.text = [NSString stringWithFormat:@"出厂日期: %@",_vinResult.ccrq ? : @"暂无"];
}


- (UIImageView *)cardView{
    if (!_cardView) {
        _cardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tool_emission_bg"]];
    }
    return _cardView;
}

- (UILabel *)emissionTitleLabel{
    if (!_emissionTitleLabel) {
        _emissionTitleLabel = [[UILabel alloc] init];
        _emissionTitleLabel.text = @"排放";
        _emissionTitleLabel.textColor = [UIColor colorWithHexString:@"c3c3c3"];
        _emissionTitleLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
    }
    return _emissionTitleLabel;
}


- (UILabel *)emissionValueLabel{
    if (!_emissionValueLabel) {
        _emissionValueLabel =[[UILabel alloc] init];
        _emissionValueLabel.textColor = themeColor;
        _emissionValueLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
    }
    return _emissionValueLabel;
}


- (UIImageView *)imaginaryLineView{
    if (!_imaginaryLineView) {
        _imaginaryLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imaginary_line"]];
    }
    return _imaginaryLineView;
}

- (UILabel *)carNameLabel{
    if (!_carNameLabel) {
        _carNameLabel = [[UILabel alloc] init];
        _carNameLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _carNameLabel.numberOfLines = 0;
        _carNameLabel.textColor = [UIColor blackColor];
    }
    return _carNameLabel;
}

- (UILabel *)vinLabel{
    if (!_vinLabel) {
        _vinLabel =[[UILabel alloc] init];
        _vinLabel.font = [UIFont systemFontOfSize:14];
        _vinLabel.textColor = [UIColor blackColor];
    }
    return _vinLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _dateLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dateLabel;
}

@end
