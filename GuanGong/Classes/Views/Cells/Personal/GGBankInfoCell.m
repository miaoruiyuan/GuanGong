//
//  GGBankInfoCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/14.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBankInfoCell.h"

NSString * const kCellIdentifierBankInfo = @"kGGBankInfoCell";

@interface GGBankInfoCell ()

@property(nonatomic,strong)UIImageView *bankIcon;
@property(nonatomic,strong)UILabel *bankName;

@end

@implementation GGBankInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        if (!_bankIcon) {
            _bankIcon = [[UIImageView alloc]initWithFrame:CGRectMake(kLeftPadding, 0, 32, 32)];
            _bankIcon.centerY = self.contentView.centerY;
            [self.contentView addSubview:_bankIcon];
        }
        
        if (!_bankName) {
            _bankName = [[UILabel alloc]initWithFrame:CGRectMake(_bankIcon.right + 14, 0, 288, 20)];
            _bankName.centerY = _bankIcon.centerY;
            _bankName.font = [UIFont systemFontOfSize:15.6 weight:UIFontWeightRegular];
            _bankName.textColor = textNormalColor;
            [self.contentView addSubview:_bankName];
        }
    }
    return self;
}

- (void)setBank:(GGBank *)bank
{
    if (_bank != bank) {
        _bank = bank;
        
        [_bankIcon setImageWithURL:[NSURL URLWithString:_bank.logo] placeholder:[UIImage imageNamed:@"user_header_default"]];
        _bankName.text = _bank.bankName;
    }
}

+ (CGFloat)cellHeight
{
    return 44.0;
}

@end
