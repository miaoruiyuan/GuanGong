
//
//  GGCapitalClearListCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCapitalClearListCell.h"

@interface GGCapitalClearListCell ()

@property(nonatomic,strong)UIImageView *stateView;
@property(nonatomic,strong)UILabel *bankLabel;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *amountLabel;


@end

NSString * const kCellIdentifierCaptialClear = @"kGGCapitalClearListCell";
@implementation GGCapitalClearListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.stateView];
        [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kLeftPadding);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.contentView addSubview:self.bankLabel];
        [self.bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stateView.mas_right).offset(12);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.height.mas_equalTo(16);
        }];
        
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bankLabel);
            make.top.equalTo(self.bankLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10).priority(710);
        }];
        
        [self.contentView addSubview:self.amountLabel];
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-14);
            make.centerY.equalTo(self.bankLabel);
            make.height.mas_equalTo(15);
        }];
        
    }
    return self;
}


- (void)setClearList:(GGCapitalClearList *)clearList{
    if (_clearList != clearList) {
        _clearList = clearList;
        

        switch (_clearList.status) {
            case 0:
                self.stateView.image = [UIImage imageNamed:@"paymentDetail_wait"];
                break;
                
            case 1:
                self.stateView.image = [UIImage imageNamed:@"paymentDetail_success"];
                break;

            case 2:
                self.stateView.image = [UIImage imageNamed:@"paymentDetail_refuse"];
                break;

            default:
                break;
        }
        
        
        
        
        
        self.bankLabel.text = _clearList.title;
        self.dateLabel.text = _clearList.createTimeStr;
        self.amountLabel.text = _clearList.amount;
        
        
    }
}


- (UIImageView *)stateView{
    if (!_stateView) {
        _stateView = [[UIImageView alloc] init];
    }
    return _stateView;
}

- (UILabel *)bankLabel{
    if (!_bankLabel) {
        _bankLabel = [[UILabel alloc] init];
        _bankLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
        _bankLabel.textColor = textNormalColor;
    }
    return _bankLabel;
}


- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = textLightColor;
        _dateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
    }
    return _dateLabel;
}


- (UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _amountLabel.textColor = [UIColor blackColor];
    }
    return _amountLabel;
}









@end
