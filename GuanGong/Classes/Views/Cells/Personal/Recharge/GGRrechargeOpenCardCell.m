//
//  GGRrechargeOpenCardCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/7/25.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGRrechargeOpenCardCell.h"

NSString * const kGGRrechargeOpenCardCellID = @"GGRrechargeOpenCardCell";

@interface GGRrechargeOpenCardCell()

@property(nonatomic,strong)UIImageView *bankIcon;
@property(nonatomic,strong)UILabel *bankNameLabel;
@property(nonatomic,strong)UILabel *moneyLabel;

@end


@implementation GGRrechargeOpenCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!_bankIcon) {
            _bankIcon = [[UIImageView alloc]init];
            _bankIcon.layer.masksToBounds = YES;
            _bankIcon.layer.cornerRadius = 19;
            [self.contentView addSubview:_bankIcon];
        }
        
        if (!_bankNameLabel) {
            _bankNameLabel = [[UILabel alloc]init];
            _bankNameLabel.textColor = [UIColor colorWithHexString:@"000000"];
            _bankNameLabel.font = [UIFont systemFontOfSize:15];
            [self.contentView addSubview:_bankNameLabel];
        }
        
        if (!_moneyLabel) {
            _moneyLabel = [[UILabel alloc]init];
            _moneyLabel.textColor = [UIColor colorWithHexString:@"737373"];
            _moneyLabel.font = [UIFont systemFontOfSize:13];
            [self.contentView addSubview:_moneyLabel];
        }
        
        
        [_bankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(38);
        }];
        
        [_bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bankIcon.mas_right).offset(10);
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-2);
        }];
        
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bankIcon.mas_right).offset(10);
            make.top.equalTo(self.contentView.mas_centerY).offset(4);
        }];
    }
    return self;
}

- (void)showRechargeBankCard:(GGBankRechargeListModel *)model
{
    _bankNameLabel.text = [NSString stringWithFormat:@"%@ (%@)",model.plantBankName,model.accNo];
//    if ([model.cardType isEqualToString:@"01"]) {
//        _moneyLabel.text = @"限额1,000,000.00元";
//    }else if ([model.cardType isEqualToString:@"02"]){
//        _moneyLabel.text = @"限额1,000,000.00元";
//    }
//    
    _moneyLabel.text = [NSString stringWithFormat:@"限额%@元",model.singleLimit];
    [_bankIcon setImageWithURL:[NSURL URLWithString:model.logo] placeholder:[UIImage imageNamed:@"choose_bankCard_list_icon"]];
}


@end
