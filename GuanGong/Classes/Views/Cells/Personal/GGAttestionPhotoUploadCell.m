//
//  GGIdCardCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/5/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGAttestionPhotoUploadCell.h"
#import "GGQiNiuPrivateImageView.h"

@interface GGAttestionPhotoUploadCell ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)GGQiNiuPrivateImageView *cardImageView;

@end

NSString * const kGGAttestionPhotoUploadCellID = @"GGAttestionPhotoUploadCell";

@implementation GGAttestionPhotoUploadCell

@synthesize titleLabel = _titleLabel;

- (void)setupView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(1);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(15);
    }];

    [self.contentView addSubview:self.cardImageView];
    [self.cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(198,123));
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
}

- (void)configCompanyItem:(GGFormItem *)item
{
    [self configItem:item];
    
    if (item.title.length > 0) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(16);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(15);
        }];
        [self.cardImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.width.mas_equalTo(198);
            make.top.mas_equalTo(44);
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
    }else{
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(1);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(0);
        }];
        [self.cardImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.width.mas_equalTo(198);
            make.top.mas_equalTo(4);
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
    }
}

- (void)configItem:(GGFormItem *)item{
    
    [super configItem:item];
    NSString *placeholder = item.pageContent;
    [self.cardImageView gg_setImageeURL:item.obj placeholder:[UIImage imageNamed:placeholder]];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = textLightColor;
    }
    return _titleLabel;
}

- (GGQiNiuPrivateImageView *)cardImageView{
    if (!_cardImageView) {
        _cardImageView = [[GGQiNiuPrivateImageView alloc] init];
        _cardImageView.contentMode = UIViewContentModeScaleAspectFill;
        _cardImageView.clipsToBounds = YES;
    }
    return _cardImageView;
}


@end
