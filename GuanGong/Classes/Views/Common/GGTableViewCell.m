//
//  GGTableViewCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/16.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewCell.h"

@implementation GGTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}


-(void)setupView{
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_lessThanOrEqualTo(78).with.priority(710);
    }];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = textNormalColor;
        _titleLabel.font = [UIFont systemFontOfSize:15.4];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
@end
