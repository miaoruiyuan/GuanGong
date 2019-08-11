
//
//  GGFriendInfoCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/2.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFriendInfoCell.h"

@interface GGFriendInfoCell ()

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *valueLabel;

@end

NSString * const kCellIdentifierFeiendInfo = @"kGGFriendInfoCell";

@implementation GGFriendInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(kLeftPadding);
            make.size.mas_equalTo(CGSizeMake(76, 18));
        }];
        
        [self.contentView addSubview:self.valueLabel];
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(15);
            make.centerY.equalTo(self.titleLabel);
        }];
    }
    return self;
}


- (void)updateUIWithTitle:(NSString *)title value:(NSString *)value
{
    self.titleLabel.text = title;
    self.valueLabel.text = value;
}

#pragma mark - init view 

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = textNormalColor;
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    }
    return _titleLabel;
}

- (UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = textLightColor;
        _valueLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    }
    return _valueLabel;
}

@end
