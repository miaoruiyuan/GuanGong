//
//  GGImageViewTitleCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGImageViewTitleCell.h"

NSString *const kCellIdentifierImageViewTitle = @"kGGImageViewTitleCell";

@implementation GGImageViewTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        

        [self.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(kLeftPadding);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView.mas_right).offset(12);
            make.centerY.equalTo(self.imgView);
            make.size.mas_equalTo(CGSizeMake(180, 18));
        }];
        
    }
    return self;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
    }
    return _imgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel =  [[UILabel alloc]init];
        _titleLabel.textColor = textNormalColor;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

@end
