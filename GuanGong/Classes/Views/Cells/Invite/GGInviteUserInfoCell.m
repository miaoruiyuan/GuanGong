//
//  GGInviteUserInfoCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/3/22.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGInviteUserInfoCell.h"

@interface GGInviteUserInfoCell()
{
}

@property (nonatomic,strong)UILabel *phoneLabel;

@property (nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,strong)UILabel *realNameLabel;


@end

@implementation GGInviteUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
        [self.contentView addSubview:self.phoneLabel];
        
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(12);
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView).offset(12);
        }];
        
        [self.contentView addSubview:self.realNameLabel];
        [self.realNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.contentView).offset(-12);
        }];
    }
    return self;
}


- (void)updateUIWithModel:(GGInvite *)model
{
    self.phoneLabel.text = model.mobilePhone;
    self.timeLabel.text = [NSDate dateWithTimeIntreval:model.updateTime];
    
    if (model.auditingType == 1) {
        self.realNameLabel.text = model.realName;
    }else{
        self.realNameLabel.text = @"未认证";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - init View

- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.font = [UIFont systemFontOfSize:15];
        _phoneLabel.textColor = textNormalColor;
    }
    return _phoneLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = textLightColor;
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)realNameLabel{
    if (!_realNameLabel) {
        _realNameLabel = [[UILabel alloc]init];
        _realNameLabel.font = [UIFont systemFontOfSize:13];
        _realNameLabel.textColor = textLightColor;
    }
    return _realNameLabel;
}

@end
