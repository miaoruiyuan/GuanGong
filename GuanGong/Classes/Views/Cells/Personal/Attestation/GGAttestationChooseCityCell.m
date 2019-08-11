//
//  GGAttestationChooseCityCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/5.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGAttestationChooseCityCell.h"

NSString *const kGGAttestationChooseCityCellID = @"GGAttestationChooseCityCell";

@interface GGAttestationChooseCityCell()

@property (nonatomic,strong)UIImageView *locationImageView;

@end

@implementation GGAttestationChooseCityCell

@synthesize titleLabel = _titleLabel;
@synthesize arrowView = _arrowView;

- (void)configItem:(GGFormItem *)item
{
    self.titleLabel.text = item.title;
    UIColor *color = [UIColor blackColor];
    self.inputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请选择" attributes:@{NSForegroundColorAttributeName: color}];
    self.inputTextField.text = item.obj;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.titleLabel.highlighted = highlighted;
    if (highlighted) {
        self.inputTextField.backgroundColor = [UIColor colorWithHexString:@"FCFCFC"];
    }else{
        self.inputTextField.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    }
}

- (void)setupView{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(15);
    }];
    
    [self.contentView addSubview:self.inputTextField];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(14);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(198, 36));
    }];
}

#pragma mark - initView

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = textLightColor;
        _titleLabel.highlightedTextColor = TextColor;
    }
    return _titleLabel;
}

- (UITextField *)inputTextField
{
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.font = [UIFont systemFontOfSize:15];
        _inputTextField.textAlignment = NSTextAlignmentLeft;
        _inputTextField.textColor = [UIColor blackColor];
        _inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

        _inputTextField.enabled = NO;
        _inputTextField.layer.masksToBounds = YES;
        _inputTextField.layer.cornerRadius = 2;
        _inputTextField.layer.borderColor = [UIColor colorWithHexString:@"d7d7d7"].CGColor;
        _inputTextField.layer.borderWidth = 0.5f;
        _inputTextField.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        
        _inputTextField.leftViewMode = UITextFieldViewModeAlways;
        _inputTextField.rightViewMode = UITextFieldViewModeAlways;
        
        _inputTextField.leftView = self.locationImageView;
        _inputTextField.rightView = self.arrowView;
    }
    return _inputTextField;
}

- (UIImageView *)arrowView{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right_small"] highlightedImage:[UIImage imageNamed:@"arrow_right_small"]];
        _arrowView.frame = CGRectMake(0,0,40,40);
        _arrowView.contentMode = UIViewContentModeCenter;
    }
    return _arrowView;
}

- (UIImageView *)locationImageView
{
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Attestation_car_location_icon"]];
        _locationImageView.frame = CGRectMake(0,0,40,40);
        _locationImageView.contentMode = UIViewContentModeCenter;
    }
    return _locationImageView;
}

@end
