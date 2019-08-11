//
//  GGMyFriendsCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/4.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMyFriendsCell.h"

NSString * const kCellIdentifierMyFeiend = @"kGGMyFriendsCell";

@interface GGMyFriendsCell ()

@property(nonatomic,strong)UIImageView *userFaceImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *realNameLabel;

@end

@implementation GGMyFriendsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    [self.contentView addSubview:self.userFaceImageView];
    [self.userFaceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(kLeftPadding);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(36);
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userFaceImageView.mas_right).offset(15);
        make.top.equalTo(self.userFaceImageView.mas_top);
        make.height.mas_equalTo(18);
    }];
    
    
    [self.contentView addSubview:self.realNameLabel];
    [self.realNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
        make.height.mas_equalTo(14);
    }];
}

- (void)setList:(GGFriendsList *)list
{
    _list = list;
    
    [self.userFaceImageView setImageWithURL:[NSURL URLWithString:_list.iconUrl ? _list.iconUrl : _list.icon] placeholder:[UIImage imageNamed:@"user_header_default"]];
    
    self.nameLabel.text = _list.remark ? _list.remark : _list.mobile;
    
    self.realNameLabel.text = _list.auditingType == FriendAuditPass ? [NSString stringWithFormat:@"真实姓名:%@",_list.realName] : @"未认证";
}

#pragma mark - init View

- (UIImageView *)userFaceImageView{
    if (!_userFaceImageView) {
        _userFaceImageView = [[UIImageView alloc]init];
        _userFaceImageView.contentMode = UIViewContentModeScaleAspectFill;
        _userFaceImageView.layer.masksToBounds = YES;
        _userFaceImageView.layer.cornerRadius = 2.2;
    }
    return _userFaceImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = textNormalColor;
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}

- (UILabel *)realNameLabel{
    if (!_realNameLabel) {
        _realNameLabel = [[UILabel alloc]init];
        _realNameLabel.textColor = textLightColor;
        _realNameLabel.font = [UIFont systemFontOfSize:12];
    }
    return _realNameLabel;
}

@end
