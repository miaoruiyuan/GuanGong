//
//  GGMineInfoView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/5/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMineInfoView.h"

@interface GGMineInfoView ()

@property(nonatomic,strong)GGTapImageView *headerIcon;
@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *personAudingStatusLabel;
@property(nonatomic,strong)UILabel *companyAudingStatusLabel;

@property(nonatomic,strong)UIImageView *accessView;

@end

@implementation GGMineInfoView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
    
        [self addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(10);
            make.left.equalTo(self.mas_left).with.offset(kLeftPadding);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView.mas_right).offset(20);
            make.top.equalTo(self.headerView.mas_top).with.offset(6);
            make.height.mas_equalTo(18);
        }];
        
        [self addSubview:self.personAudingStatusLabel];
        [self.personAudingStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.headerView.mas_centerY).offset(6);
            make.size.mas_equalTo(CGSizeMake(56, 18));
        }];
        
        [self addSubview:self.companyAudingStatusLabel];
        [self.companyAudingStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.personAudingStatusLabel.mas_right).offset(5);
            make.top.equalTo(self.headerView.mas_centerY).offset(6);
            make.size.mas_equalTo(CGSizeMake(76, 18));
        }];

        
        [self addSubview:self.accessView];
        [self.accessView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.centerY.equalTo(self).offset(6);
            make.right.equalTo(self.mas_right).offset(-13);
        }];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self.headerView setImageWithURL:[NSURL URLWithString:[GGLogin shareUser].user.headPic]
                            placeholder:[UIImage imageNamed:@"user_header_default"]
                                options:YYWebImageOptionAllowInvalidSSLCertificates
                               progress:nil
                              transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                        
                                  return [image imageByResizeToSize:CGSizeMake(240, 240) contentMode:UIViewContentModeScaleAspectFill];
                              }
                             completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                
                             }];
    
    if ([GGLogin shareUser].user.auditingType == AuditingTypePass ) {
        self.personAudingStatusLabel.text = @"已实名";
        self.personAudingStatusLabel.textColor = [UIColor whiteColor];
        self.personAudingStatusLabel.backgroundColor = [UIColor colorWithHexString:@"42b2f6"];
        NSString *userName = [GGLogin shareUser].user.realName;
        if (userName && userName.length > 0 ) {
            self.nameLabel.text = userName;
        }else{
            self.nameLabel.text = [GGLogin shareUser].user.mobile;
        }
    }else{
        self.personAudingStatusLabel.text = @"未实名";
        self.personAudingStatusLabel.backgroundColor = [UIColor colorWithHexString:@"ededed"];
        self.personAudingStatusLabel.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        self.nameLabel.text = [GGLogin shareUser].user.mobile;
    }
    
    if ([GGLogin shareUser].user.companyAuditingType == CompanyAuditingTypePass) {
        self.companyAudingStatusLabel.hidden = NO;
        self.companyAudingStatusLabel.text = @"企业已认证";
        self.companyAudingStatusLabel.backgroundColor = [UIColor colorWithHexString:@"508cee"];
        self.companyAudingStatusLabel.textColor = [UIColor whiteColor];
    }else{
        self.companyAudingStatusLabel.hidden = YES;
    }

}

- (UIImageView *)headerView{
    if (!_headerIcon) {
        _headerIcon = [[GGTapImageView alloc]init];
        _headerIcon.layer.masksToBounds = YES;
        _headerIcon.layer.cornerRadius = 3.6;
    }
    return _headerIcon;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:17.2 weight:UIFontWeightRegular];
    }
    return _nameLabel;
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


- (UIImageView *)accessView{
    if (!_accessView) {
        _accessView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_small"]];
    }
    return _accessView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
