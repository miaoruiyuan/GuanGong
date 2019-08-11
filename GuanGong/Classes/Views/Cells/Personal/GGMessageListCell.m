//
//  GGMessageListCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/6/14.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGMessageListCell.h"

NSString *const kGGMessageListCellID = @"GGMessageListCell";

@interface GGMessageListCell()
{

}

@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *desLabel;
@property (nonatomic,strong)UILabel *timeLabel;

@end

@implementation GGMessageListCell
@synthesize titleLabel = _titleLabel;

- (void)setupView
{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.desLabel];
    [self.contentView addSubview:self.timeLabel];
}

- (void)showUIWithModel:(NSObject *)model
{
    
}

#pragma mark - init View

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont boldSystemFontOfSize:15];
        _desLabel.textColor = [UIColor blackColor];
    }
    return _desLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfSize:15];
        _timeLabel.textColor = [UIColor blackColor];
    }
    return _timeLabel;
}


- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
//        _iconImageView.badgeBgColor
    }
    return  _iconImageView;
}


@end
