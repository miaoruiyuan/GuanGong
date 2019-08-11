//
//  GGPingAnBankInfoCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/3/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGPingAnBankInfoCell.h"

@interface GGPingAnBankInfoCell ()
{

}

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *contentLabel;


@end

@implementation GGPingAnBankInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

- (void)showTitle:(NSString *)title content:(NSString *)content
{
    self.titleLabel.text = title;
    self.contentLabel.attributedText = [content attributedStringWithLineSpace:6];
}

#pragma mark - init View

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"8e8e8e"];
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = kScreenWidth - 24;
        _contentLabel.font = [UIFont systemFontOfSize:13];
    }
    return _contentLabel;
}

@end
