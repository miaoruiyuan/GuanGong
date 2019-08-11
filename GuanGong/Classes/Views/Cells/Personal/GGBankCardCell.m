//
//  GGBrandCardCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBankCardCell.h"

@interface GGBankCardCell ()

@property(nonatomic,strong)UIImageView *bankIcon;
@property(nonatomic,strong)UILabel *bankNameLabel;
@property(nonatomic,strong)UILabel *cardTypeLabel;
@property(nonatomic,strong)UILabel *cardNumberLabel;

@end

NSString * const kCellIdentifierBankCardCell = @"kGGBankCardCell";

@implementation GGBankCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"card_bg"]];
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(6,6,6,6));
        }];
        
        if (!_bankIcon) {
            _bankIcon = [[UIImageView alloc]init];
            _bankIcon.backgroundColor =  [UIColor whiteColor];
            _bankIcon.layer.masksToBounds = YES;
            _bankIcon.layer.cornerRadius = 19;
            [bgView addSubview:_bankIcon];
        }
        
        if (!_bankNameLabel) {
            _bankNameLabel = [[UILabel alloc]init];
            _bankNameLabel.textColor = [UIColor whiteColor];
            _bankNameLabel.font = [UIFont systemFontOfSize:16];
            [bgView addSubview:_bankNameLabel];
        }
        
        if (!_cardTypeLabel) {
            _cardTypeLabel = [[UILabel alloc]init];
            _cardTypeLabel.textColor = [UIColor whiteColor];
            _cardTypeLabel.font = [UIFont systemFontOfSize:13.2];
            [bgView addSubview:_cardTypeLabel];
        }
        
        if (!_cardNumberLabel) {
            _cardNumberLabel = [[UILabel alloc]init];
            _cardNumberLabel.textColor = [UIColor whiteColor];
            _cardNumberLabel.font = [UIFont boldSystemFontOfSize:18];
            [bgView addSubview:_cardNumberLabel];
        }
        
        [_bankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kLeftPadding);
            make.top.mas_equalTo(12);
            make.width.height.mas_equalTo(38);
        }];

        [_bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bankIcon.mas_right).offset(kLeftPadding);
            make.top.equalTo(_bankIcon);
        }];
        
        [_cardTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bankNameLabel);
            make.top.equalTo(_bankNameLabel.mas_bottom).offset(4);
        }];
    
        [_cardNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cardTypeLabel.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-20);
        }];
    }
    return self;
}

- (void)setCard:(GGBankCard *)card
{
    if (_card != card) {
        _card = card;
        _bankNameLabel.text = _card.bankTitle;
        _cardTypeLabel.text = @"储蓄卡";
        _cardNumberLabel.text = [NSString stringWithFormat:@"*************%@",[_card.idCode substringFromIndex:_card.idCode.length - 4]];
        [_bankIcon setImageWithURL:[NSURL URLWithString:_card.bankLogo] placeholder:[UIImage imageNamed:@"user_header_default"]];
    }
}

@end
