//
//  GGNewCarListCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/9.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGNewCarListCell.h"

NSString *const kGGNewCarListCellID = @"GGNewCarListCell";

@interface GGNewCarListCell()
{
    
}

@property (nonatomic,strong)UIView *leftTagBGView;
@property (nonatomic,strong)UILabel *leftTagLabel;

@property (nonatomic,strong)UIImageView *carImageView;

@property (nonatomic,strong)UIImageView *noCarTipImageView;

@property (nonatomic,strong)UILabel *carNameLabel;
@property (nonatomic,strong)UILabel *carPriceLabel;

@property (nonatomic,strong)CAShapeLayer *shapeLayer;


@end

@implementation GGNewCarListCell

- (void)setupView
{
    [self.contentView addSubview:self.carImageView];
    [self.carImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo((kScreenWidth - 40) * 0.5f).priorityHigh();
    }];
    
    [self.carImageView addSubview:self.noCarTipImageView];
    [self.noCarTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.carImageView);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [self.carImageView addSubview:self.leftTagBGView];
    [self.leftTagBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.carImageView);
        make.size.mas_equalTo(CGSizeMake(70, 25));
    }];
    
    [self.leftTagBGView addSubview:self.leftTagLabel];
    [self.leftTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self.leftTagBGView);
        make.right.equalTo(self.leftTagBGView).offset(-4);
    }];
    
    [self.contentView addSubview:self.carNameLabel];
    [self.carNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.carImageView.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView).offset(-15).priorityLow();
    }];
    
    [self.contentView addSubview:self.carPriceLabel];
    [self.carPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.carNameLabel);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)updateUIWithModel:(GGNewCarListModel *)model
{
    [self.carImageView setImageWithURL:[NSURL URLWithString:model.carPhotoUrl] placeholder:[UIImage imageNamed:@"car_detail_image_failed"]];
    self.carNameLabel.text = model.title;
    
    CGFloat price = [model.price floatValue] / 10000.0;
    self.carPriceLabel.text = [NSString stringWithFormat:@"￥%0.2f万",price];
    
    if (model.tagName) {
        self.leftTagBGView.hidden = NO;
        self.shapeLayer.fillColor = [UIColor colorWithHexString:model.colorRGB].CGColor;
        self.leftTagLabel.text = model.tagName;
    } else {
        self.leftTagBGView.hidden = YES;
    }
    
    if (model.wareStockResponse.stock > 0) {
        self.noCarTipImageView.hidden = YES;
    }else{
        self.noCarTipImageView.hidden = NO;
    }
}

#pragma mark - initView

- (UIView *)leftTagBGView
{
    if (!_leftTagBGView) {
        _leftTagBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 25)];
        
        _shapeLayer = [CAShapeLayer layer];
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        [bezier moveToPoint:CGPointMake(0,0)];
        [bezier addLineToPoint:CGPointMake(0, 25)];
        [bezier addLineToPoint:CGPointMake(60, 25)];
        [bezier addLineToPoint:CGPointMake(70, 0)];
        [bezier addLineToPoint:CGPointMake(0,0)];
        _shapeLayer.path = bezier.CGPath;
        [_leftTagBGView.layer addSublayer:_shapeLayer];
        _leftTagBGView.backgroundColor = [UIColor clearColor];
    }
    return _leftTagBGView;
}

- (UILabel *)leftTagLabel
{
    if (!_leftTagLabel) {
        _leftTagLabel = [[UILabel alloc] init];
        _leftTagLabel.font = [UIFont systemFontOfSize:13];
        _leftTagLabel.textColor = [UIColor whiteColor];
        _leftTagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftTagLabel;
}

- (UIImageView *)carImageView
{
    if (!_carImageView) {
        _carImageView = [[UIImageView alloc] init];
        _carImageView.contentMode = UIViewContentModeScaleAspectFill;
        _carImageView.clipsToBounds = YES;
    }
    return _carImageView;
}

- (UIImageView *)noCarTipImageView
{
    if (!_noCarTipImageView) {
        _noCarTipImageView = [[UIImageView alloc] init];
        _noCarTipImageView.image = [UIImage imageNamed:@"buy_new_car_listNoCount"];
    }
    return _noCarTipImageView;
}


- (UILabel *)carNameLabel
{
    if (!_carNameLabel) {
        _carNameLabel = [[UILabel alloc] init];
        _carNameLabel.font = [UIFont systemFontOfSize:15];
        _carNameLabel.textColor = [UIColor blackColor];
        _carNameLabel.numberOfLines = 0;
        _carNameLabel.preferredMaxLayoutWidth = kScreenWidth - 120;
    }
    return _carNameLabel;
}

- (UILabel *)carPriceLabel
{
    if (!_carPriceLabel) {
        _carPriceLabel = [[UILabel alloc] init];
        _carPriceLabel.font = [UIFont systemFontOfSize:16];
        _carPriceLabel.textColor = themeColor;
        _carPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _carPriceLabel;
}

@end
