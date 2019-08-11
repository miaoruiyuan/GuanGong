//
//  GGVehicleOwnerCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/14.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGVehicleOwnerCell.h"
#import "TTTAttributedLabel.h"

@interface GGVehicleOwnerCell ()

@property(nonatomic,strong)UIImageView *faceView;
@property(nonatomic,strong)TTTAttributedLabel *nameLabel;

@property(nonatomic,strong)UILabel *personAudingStatusLabel;
@property(nonatomic,strong)UILabel *companyAudingStatusLabel;



@end

NSString *const kCellIdentifierVehicleOwner = @"kGGVehicleOwnerCell";

@implementation GGVehicleOwnerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.contentView.tintColor = [UIColor blackColor];
        
        [self.contentView addSubview:self.faceView];
        [self.faceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.faceView.mas_right).offset(10);
            make.centerY.equalTo(self.faceView);
            make.height.mas_equalTo(16);
        }];
        
        [self addSubview:self.personAudingStatusLabel];
        [self.personAudingStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).offset(3);
            make.centerY.equalTo(self.nameLabel).offset(1);
            make.size.mas_equalTo(CGSizeMake(56, 18));
        }];
        
        [self addSubview:self.companyAudingStatusLabel];
        [self.companyAudingStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.personAudingStatusLabel.mas_right).offset(5);
            make.centerY.equalTo(self.nameLabel).offset(1);
            make.size.mas_equalTo(CGSizeMake(76, 18));
        }];
        
//        [self.contentView addSubview:self.audingImageView];
//        [self.audingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.nameLabel.mas_right).offset(3);
//            make.centerY.equalTo(self.nameLabel).offset(1);
//        }];

    }
    return self;
}

- (void)setInfo:(GGUser *)info
{
    if (_info != info) {
        _info = info;

        [self.faceView setImageWithURL:[NSURL URLWithString:_info.headPic] placeholder:[UIImage imageNamed:@"user_header_default"]];
        self.nameLabel.text = _info.realName;
        
        if (_info.auditingType == AuditingTypePass ) {
            self.personAudingStatusLabel.text = @"已实名";
            self.personAudingStatusLabel.textColor = [UIColor whiteColor];
            self.personAudingStatusLabel.backgroundColor = [UIColor colorWithHexString:@"42b2f6"];
            
        }else{
            self.personAudingStatusLabel.text = @"未实名";
            self.personAudingStatusLabel.backgroundColor = [UIColor colorWithHexString:@"ededed"];
            self.personAudingStatusLabel.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        }
        
        if (_info.companyAuditingType == CompanyAuditingTypePass) {
            self.companyAudingStatusLabel.hidden = NO;
            self.companyAudingStatusLabel.text = @"企业已认证";
            self.companyAudingStatusLabel.backgroundColor = [UIColor colorWithHexString:@"508cee"];
            self.companyAudingStatusLabel.textColor = [UIColor whiteColor];
        }else{
            self.companyAudingStatusLabel.hidden = YES;
        }
    }
}

- (UIImageView *)faceView{
    if (!_faceView) {
        _faceView = [[UIImageView alloc] init];
    }
    return _faceView;
}

- (TTTAttributedLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [TTTAttributedLabel new];
        _nameLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _nameLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
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
@end
