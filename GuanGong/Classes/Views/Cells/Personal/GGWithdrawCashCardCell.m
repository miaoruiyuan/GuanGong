//
//  GGWithdrawCashCardCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGWithdrawCashCardCell.h"

@interface GGWithdrawCashCardCell ()

@property(nonatomic,strong)UIImageView *bankIcon;
@property(nonatomic,strong)UILabel *bankNameLabel;
@property(nonatomic,strong)UILabel *cardNumberLabel;

@property(nonatomic,strong)UILabel *desLabel;

@end

NSString * const kCellIdentifierWithdrawCashCell = @"kCellIdentifierWithdrawCashCell";

@implementation GGWithdrawCashCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    
        if (!_bankIcon) {
            _bankIcon = [[UIImageView alloc]init];
            [self.contentView addSubview:_bankIcon];
        }
        
        if (!_bankNameLabel) {
            _bankNameLabel = [[UILabel alloc]init];
            _bankNameLabel.textColor = textNormalColor;
            _bankNameLabel.font = [UIFont systemFontOfSize:16];
            [self.contentView addSubview:_bankNameLabel];
        }
        
        if (!_cardNumberLabel) {
            _cardNumberLabel = [[UILabel alloc]init];
            _cardNumberLabel.textColor = textLightColor;
            _cardNumberLabel.font = [UIFont boldSystemFontOfSize:14];
            [self.contentView addSubview:_cardNumberLabel];
        }
        
        [_bankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kLeftPadding);
            make.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(32);
        }];
        
        [_bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bankIcon.mas_right).offset(kLeftPadding);
            make.top.equalTo(self.contentView.mas_top).with.offset(18);
        }];
        

        [_cardNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bankNameLabel);
            make.top.equalTo(_bankNameLabel.mas_bottom).offset(6);
        }];
    }
    return self;
}


- (void)setBankCard:(GGBankCard *)bankCard{
    
    _bankCard = bankCard;

    if (bankCard == nil) {
        self.accessoryType = UITableViewCellAccessoryNone;
        [_bankNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bankIcon.mas_right).offset(kLeftPadding);
            make.top.equalTo(self.contentView.mas_top).with.offset(23);
        }];
        
        _bankIcon.image = [UIImage imageNamed:@"add_bankCard_list_icon"];
        _bankNameLabel.text = @"添加储蓄卡";
        _cardNumberLabel.text = @"";
    } else {
        [_bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bankIcon.mas_right).offset(kLeftPadding);
            make.top.equalTo(self.contentView.mas_top).with.offset(18);
        }];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        [_bankIcon setImageWithURL:[NSURL URLWithString:_bankCard.bankLogo] placeholder:[UIImage imageNamed:@"choose_bankCard_list_icon"]];
        _bankNameLabel.text = _bankCard.bankTitle;
        _cardNumberLabel.text = [NSString stringWithFormat:@"尾号%@",[_bankCard.idCode substringFromIndex:_bankCard.idCode.length -4]];
    }
}

- (void)showCheckBank:(GGBankCard *)bankCard
{
    if (bankCard) {
        self.bankCard = bankCard;
        self.desLabel.hidden = YES;
    }else{
        self.desLabel.hidden = NO;
        self.desLabel.text = @"请选择预留手机号与要绑定的新手机号相同的银行卡";
        self.bankIcon.image = [UIImage imageNamed:@"choose_bankCard_list_icon"];
    }
}

- (void)showRechargeView:(GGBankRechargeListModel *)model;
{
    if (model) {
        [_bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bankIcon.mas_right).offset(kLeftPadding);
            make.top.equalTo(self.contentView.mas_top).with.offset(18);
        }];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [_bankIcon setImageWithURL:[NSURL URLWithString:model.logo] placeholder:[UIImage imageNamed:@"choose_bankCard_list_icon"]];
        _bankNameLabel.text = model.plantBankName;
        _cardNumberLabel.text = [NSString stringWithFormat:@"尾号%@",model.accNo];
        
    }else{
        [_bankNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bankIcon.mas_right).offset(kLeftPadding);
            make.top.equalTo(self.contentView.mas_top).with.offset(23);
        }];
        _bankIcon.image = [UIImage imageNamed:@"add_bankCard_list_icon"];
        _bankNameLabel.text = @"添加充值银行卡";
        _cardNumberLabel.text = @"";
    }
}

#pragma mark - init View


- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textColor = textLightColor;
        _desLabel.numberOfLines = 2;
        _desLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_desLabel];
        
        [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bankIcon.mas_right).offset(kLeftPadding);
            make.centerY.equalTo(_bankIcon);
            make.right.equalTo(self.contentView).offset(-40);
        }];
    }
    return _desLabel;
}

@end
