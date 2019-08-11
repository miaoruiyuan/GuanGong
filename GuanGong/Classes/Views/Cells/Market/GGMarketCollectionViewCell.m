
//
//  GGMarketCollectionViewCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMarketCollectionViewCell.h"

@interface GGMarketCollectionViewCell ()

@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *iconNewView;

@end

NSString *const kCellIdentifierMarketCCell = @"kGGMarketCollectionViewCell";

@implementation GGMarketCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView.mas_centerY).offset(-7);
            make.size.mas_equalTo(CGSizeMake(23, 23));
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.iconView);
            make.top.equalTo(self.iconView.mas_bottom).offset(15);
        }];
        
        [self.contentView addSubview:self.iconNewView];
        [self.iconNewView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.iconView.mas_top).offset(-1);
            make.left.equalTo(self.iconView.mas_right).offset(1);
            make.size.mas_equalTo(CGSizeMake(22, 8));
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setItem:(GGMarketItem *)item
{
    if (_item != item) {
        _item = item;
        _iconView.image = [UIImage imageNamed:_item.icon];
        _titleLabel.text = _item.title;
    }
    
    self.iconNewView.hidden = !item.showNew;
}

#pragma mark - init View

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _titleLabel.textColor = textNormalColor;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIImageView *)iconNewView{
    if (!_iconNewView) {
        _iconNewView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_tip_new_icon"]];
    }
    return _iconNewView;
}

@end
