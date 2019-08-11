//
//  GGWalletBalanceCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/12.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGWalletBalanceCell.h"
#import "GGWaterWaveView.h"

@interface GGWalletBalanceCell ()
@property(nonatomic,strong)UILabel *amountBalanceTitleLabel;
@property(nonatomic,strong)UILabel *amountBalanceValueLabel;

@property(nonatomic,strong)UILabel *canUseBalanceTitleLabel;
@property(nonatomic,strong)UILabel *canUseBalanceValueLabel;

@property(nonatomic,strong)UILabel *freezeBalanceTitleLabel;
@property(nonatomic,strong)UILabel *freezeBalanceValueLabel;

@property(nonatomic,strong)UIView *line;

@property(nonatomic,strong)GGWaterWaveView *waterWave;




@end

NSString *const kCellIdentifierWalletBalance = @"kGGWalletBalanceCell";
@implementation GGWalletBalanceCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //账户余额标题
        [self.contentView addSubview:self.amountBalanceTitleLabel];
        [self.amountBalanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(27);
            make.top.equalTo(self.contentView.mas_top).offset(40);
            make.size.mas_equalTo(CGSizeMake(120, 15));
        }];
        //账户余额
        [self.contentView addSubview:self.amountBalanceValueLabel];
        [self.amountBalanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.amountBalanceTitleLabel);
            make.top.equalTo(self.amountBalanceTitleLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(40);
        }];
        
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.amountBalanceValueLabel.mas_bottom).offset(40);
            make.height.mas_equalTo(.6);
        }];
        //可用余额标题
        [self.contentView addSubview:self.canUseBalanceTitleLabel];
        [self.canUseBalanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.amountBalanceTitleLabel);
            make.top.equalTo(self.line.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(120, 13));
        }];
        //可用余额
        [self.contentView addSubview:self.canUseBalanceValueLabel];
        [self.canUseBalanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.canUseBalanceTitleLabel);
            make.top.equalTo(self.canUseBalanceTitleLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(16);
        }];
        
        //冻结余额
        [self.contentView addSubview:self.freezeBalanceValueLabel];
        [self.freezeBalanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.canUseBalanceValueLabel);
            make.left.equalTo(self.canUseBalanceValueLabel.mas_right).offset(40);
            make.height.equalTo(self.canUseBalanceValueLabel);
        }];
        
        //冻结余额标题
        [self.contentView addSubview:self.freezeBalanceTitleLabel];
        [self.freezeBalanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.freezeBalanceValueLabel);
            make.top.equalTo(self.canUseBalanceTitleLabel);
            make.size.equalTo(self.canUseBalanceTitleLabel);
        }];
        
        
        //波纹
        self.waterWave.frame = CGRectMake(0, 240, kScreenWidth, 100);
        [self.contentView addSubview:self.waterWave];
        [self.waterWave startWave];
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.amountBalanceValueLabel.text = [NSString stringWithFormat:@"￥%@",[NSString positiveFormat:[GGLogin shareUser].wallet.totalBalance.stringValue]];
    self.canUseBalanceValueLabel.text = [NSString stringWithFormat:@"￥%@",[NSString positiveFormat:[GGLogin shareUser].wallet.totalTranOutAmount.stringValue]];
    
    self.freezeBalanceValueLabel.text = [NSString stringWithFormat:@"￥%@",[NSString positiveFormat:[GGLogin shareUser].wallet.totalFreezeAmount.stringValue]];
    

}

- (void)setWallet:(GGWallet *)wallet{
    if (_wallet != wallet) {
        _wallet = wallet;
        
        self.amountBalanceValueLabel.text = [NSString stringWithFormat:@"￥%@",[NSString positiveFormat:_wallet.totalBalance.stringValue]];
        self.canUseBalanceValueLabel.text = [NSString stringWithFormat:@"￥%@",[NSString positiveFormat:_wallet.totalTranOutAmount.stringValue]];
        self.freezeBalanceValueLabel.text = [NSString stringWithFormat:@"￥%@",[NSString positiveFormat:_wallet.totalFreezeAmount.stringValue]];
        
    }
}

- (UILabel *)amountBalanceTitleLabel{
    if (!_amountBalanceTitleLabel) {
        _amountBalanceTitleLabel = [[UILabel alloc] init];
        _amountBalanceTitleLabel.text = @"账户余额";
        _amountBalanceTitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _amountBalanceTitleLabel.textColor = [UIColor colorWithHexString:@"737373"];
    }
    return _amountBalanceTitleLabel;
}

- (UILabel *)amountBalanceValueLabel{
    if (!_amountBalanceValueLabel) {
        _amountBalanceValueLabel = [[UILabel alloc] init];
        _amountBalanceValueLabel.font = [UIFont systemFontOfSize:36 weight:UIFontWeightBold];
        _amountBalanceValueLabel.textColor = [UIColor colorWithHexString:@"353535"];
    }
    return _amountBalanceValueLabel;
}



- (UILabel *)canUseBalanceTitleLabel{
    if (!_canUseBalanceTitleLabel) {
        _canUseBalanceTitleLabel = [[UILabel alloc] init];
        _canUseBalanceTitleLabel.text = @"可提现余额";
        _canUseBalanceTitleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _canUseBalanceTitleLabel.textColor = [UIColor colorWithHexString:@"737373"];
    }
    return _canUseBalanceTitleLabel;
}

- (UILabel *)canUseBalanceValueLabel{
    if (!_canUseBalanceValueLabel) {
        _canUseBalanceValueLabel = [[UILabel alloc] init];
        _canUseBalanceValueLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _canUseBalanceValueLabel.textColor = [UIColor colorWithHexString:@"353535"];
    }
    return _canUseBalanceValueLabel;
}


- (UILabel *)freezeBalanceTitleLabel{
    if (!_freezeBalanceTitleLabel) {
        _freezeBalanceTitleLabel = [[UILabel alloc] init];
        _freezeBalanceTitleLabel.text = @"担保中金额";
        _freezeBalanceTitleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _freezeBalanceTitleLabel.textColor = [UIColor colorWithHexString:@"737373"];
    }
    return _freezeBalanceTitleLabel;
}

- (UILabel *)freezeBalanceValueLabel{
    if (!_freezeBalanceValueLabel) {
        _freezeBalanceValueLabel = [[UILabel alloc] init];
        _freezeBalanceValueLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _freezeBalanceValueLabel.textColor = [UIColor colorWithHexString:@"353535"];
    }
    return _freezeBalanceValueLabel;
}


- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = sectionColor;
    }
    return _line;
}

- (GGWaterWaveView *)waterWave{
    if (!_waterWave) {
        _waterWave = [[GGWaterWaveView alloc] init];
        _waterWave.percent = .6;
        _waterWave.firstWaveColor = [UIColor colorWithRGB:0xff5959 alpha:.2];
        _waterWave.secondWaveColor = [UIColor colorWithRGB:0xff5959 alpha:.8];
        _waterWave.thirdWaveColor = [UIColor whiteColor];
    }
    return _waterWave;
}


- (void)dealloc{
    [self.waterWave stopWave];
    [self.waterWave reset];
}


@end
