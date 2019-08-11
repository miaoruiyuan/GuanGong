//
//  GGFriendInfoView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFriendInfoView.h"
#import "MJPhotoBrowser.h"

@interface GGFriendInfoView ()

@property(nonatomic,strong)GGTapImageView *headerImage;
//@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *nickNameLabel;
@property(nonatomic,strong)UILabel *personAudingStatusLabel;
@property(nonatomic,strong)UILabel *companyAudingStatusLabel;

@end

@implementation GGFriendInfoView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.headerImage];
        [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(12);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(55, 55));
        }];

        [self addSubview:self.nickNameLabel];
        [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerImage.mas_right).offset(20);
            make.bottom.equalTo(self.mas_centerY).offset(-6);
            make.height.mas_equalTo(18);
        }];
        
        [self addSubview:self.personAudingStatusLabel];
        [self.personAudingStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nickNameLabel);
            make.top.equalTo(self.mas_centerY).offset(6);
            make.size.mas_equalTo(CGSizeMake(56, 18));
        }];
        
        [self addSubview:self.companyAudingStatusLabel];
        [self.companyAudingStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.personAudingStatusLabel.mas_right).offset(5);
            make.top.equalTo(self.mas_centerY).offset(6);
            make.size.mas_equalTo(CGSizeMake(76, 18));
        }];

        @weakify(self);
        [self.headerImage addTapBlock:^(GGTapImageView *obj) {
            @strongify(self);
            if (self.friendInfo.iconUrl) {
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:self.friendInfo.iconUrl];
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                browser.showSaveBtn = NO;
                browser.photos = @[photo];
                [browser show];
            }
        }];
    }

    return self;
}

- (void)setFriendInfo:(GGFriendInfo *)friendInfo{
    if (_friendInfo != friendInfo) {
        _friendInfo = friendInfo;
        
        [self.headerImage setImageWithURL:[NSURL URLWithString:_friendInfo.iconUrl] placeholder:[UIImage imageNamed:@"user_header_default"]];
        
        if (_friendInfo.remark) {
            self.nickNameLabel.text = _friendInfo.remark;
        } else if (_friendInfo.realName) {
            self.nickNameLabel.text = _friendInfo.realName;
        } else {
            self.nickNameLabel.text = _friendInfo.mobile;
        }
        
        
        if (_friendInfo.auditingType == FriendAuditPass ) {
            self.personAudingStatusLabel.text = @"已实名";
            self.personAudingStatusLabel.textColor = [UIColor whiteColor];
            self.personAudingStatusLabel.backgroundColor = [UIColor colorWithHexString:@"42b2f6"];
           
        }else{
            self.personAudingStatusLabel.text = @"未实名";
            self.personAudingStatusLabel.backgroundColor = [UIColor colorWithHexString:@"ededed"];
            self.personAudingStatusLabel.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        }
        
        if (_friendInfo.company.auditStatus == CompanyAuditingTypePass) {
            self.companyAudingStatusLabel.hidden = NO;
            self.companyAudingStatusLabel.text = @"企业已认证";
            self.companyAudingStatusLabel.backgroundColor = [UIColor colorWithHexString:@"508cee"];
            self.companyAudingStatusLabel.textColor = [UIColor whiteColor];
        }else{
            self.companyAudingStatusLabel.hidden = YES;
        }
    }
}


- (GGTapImageView *)headerImage{
    if (!_headerImage) {
        _headerImage = [[GGTapImageView alloc] init];
        _headerImage.contentMode = UIViewContentModeScaleAspectFill;
        _headerImage.clipsToBounds = YES;
    }
    return _headerImage;
}

- (UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = textNormalColor;
        _nickNameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }
    return _nickNameLabel;
}

- (UILabel *)personAudingStatusLabel{
    if (!_personAudingStatusLabel) {
        _personAudingStatusLabel = [[UILabel alloc] init];
        _personAudingStatusLabel.textAlignment = NSTextAlignmentCenter;
        _personAudingStatusLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
        _personAudingStatusLabel.layer.masksToBounds = YES;
        _personAudingStatusLabel.layer.cornerRadius = 9;
    }
    return _personAudingStatusLabel;
}

- (UILabel *)companyAudingStatusLabel{
    if (!_companyAudingStatusLabel) {
        _companyAudingStatusLabel = [[UILabel alloc] init];
        _companyAudingStatusLabel.textAlignment = NSTextAlignmentCenter;
        _companyAudingStatusLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
        _companyAudingStatusLabel.layer.masksToBounds = YES;
        _companyAudingStatusLabel.layer.cornerRadius = 9;
    }
    return _companyAudingStatusLabel;
}

@end
