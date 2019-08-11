
//
//  GGBillDetailDealerCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBillDetailDealerCell.h"

@interface GGBillDetailDealerCell ()

@property(nonatomic,strong)UIImageView *userFaceView;
@property(nonatomic,strong)UILabel *nameLabel;


@end

NSString * const  kCellIdentifierBillDetailDealer = @"kGGBillDetailDealerCell";
@implementation GGBillDetailDealerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self.contentView addSubview:self.userFaceView];
        [self.userFaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(kLeftPadding);
            make.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(36);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userFaceView.mas_right).offset(15);
            make.centerY.equalTo(self.userFaceView);
            make.height.mas_equalTo(18);
        }];
        
        
    }
    return self;
}




- (UIImageView *)userFaceView{
    if (!_userFaceView) {
        _userFaceView = [[UIImageView alloc]init];
        _userFaceView.layer.masksToBounds = YES;
        _userFaceView.layer.cornerRadius = 2.2;
    }
    return _userFaceView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = textNormalColor;
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}


@end
