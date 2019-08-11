//
//  GGVehicleInfoCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGVehicleInfoCell.h"
#import "TTTAttributedLabel.h"
#import "NSDate+Common.h"

@interface GGVehicleInfoCell ()

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *otherInfoLabel;
@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UIImageView *reservePriceBg;
@property(nonatomic,strong)UILabel *reservePriceLabel;
@property(nonatomic,strong)UILabel *updateDateLabel;

//@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UILabel *remarkLabel;
@property(nonatomic,strong)UILabel *carCountLalbel;

@end

NSString *const kCellIdentifierVehicleInfo = @"kGGVehicleInfoCell";

@implementation GGVehicleInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 150);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.top.equalTo(self.contentView).offset(25);
            make.height.mas_equalTo(20);
        }];
        
        [self.contentView addSubview:self.reservePriceBg];
        [self.reservePriceBg addSubview:self.reservePriceLabel];
        [self.reservePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.reservePriceBg).insets(UIEdgeInsetsMake(0, 8, 0, 4));
            make.height.mas_offset(14);
        }];
        
        [self.reservePriceBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceLabel.mas_right).offset(5);
            make.centerY.equalTo(self.priceLabel).offset(2);
            make.bottom.equalTo(self.reservePriceLabel.mas_bottom);
            make.right.equalTo(self.reservePriceLabel.mas_right).offset(4);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLabel.mas_bottom).offset(20);
            make.left.equalTo(self.contentView).offset(12);
//            make.right.equalTo(self.contentView).offset(-12);
        }];
        
        [self.contentView addSubview:self.otherInfoLabel];
        [self.otherInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(16);
        }];

        [self.contentView addSubview:self.remarkLabel];
        [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.otherInfoLabel.mas_bottom).offset(20);
            make.left.equalTo(self.contentView).offset(12);
//            make.right.equalTo(self.contentView).offset(-12);
        }];

        [self.contentView addSubview:self.updateDateLabel];
        [self.updateDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.remarkLabel.mas_bottom).offset(12);
            make.left.equalTo(self.priceLabel);
            make.bottom.equalTo(self.contentView).offset(-12).priorityLow();
            make.height.mas_equalTo(15);
        }];
        
//        [self.contentView addSubview:self.line];
//        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.updateDateLabel.mas_bottom).offset(12);
//            make.left.right.equalTo(self.contentView);
//            make.height.mas_equalTo(.7);
//        }];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    return self;
}

- (void)setCar:(GGCar *)car{
    if (_car != car) {
        _car = car;
        
        self.nameLabel.text = _car.titleL;

        self.otherInfoLabel.text = [NSString stringWithFormat:@"%@ %@ | %@万公里 | %@",_car.provinceStr,_car.cityStr,_car.km,_car.firstRegDate];
        
        NSString *priceStr = [NSString stringWithFormat:@"%.2f万元",[_car.price floatValue]/10000];
        self.priceLabel.text = priceStr;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceStr];
        
        NSRange markRange = [priceStr rangeOfString:@"万元" options:NSCaseInsensitiveSearch];
        
        [attributedString setAttributes:@{NSForegroundColorAttributeName: themeColor,NSFontAttributeName : [UIFont systemFontOfSize:14 weight:UIFontWeightRegular]} range:markRange];
        
        [self.priceLabel setAttributedText:attributedString];
        self.reservePriceLabel.text = [NSString stringWithFormat:@"订金:%@元",_car.reservePrice];
     
        if (_car.updateTime.length > 10) {
            self.updateDateLabel.text = [NSString stringWithFormat:@"%@更新",[_car.updateTime substringToIndex:10]];
        }else{
            self.updateDateLabel.text = @"";
        }
        self.remarkLabel.text = _car.remark;
    }
}


- (void)updateUIWithModel:(GGNewCarDetailModel *)detailModel
{
    self.nameLabel.text = detailModel.titleL;
    
    self.otherInfoLabel.text = [NSString stringWithFormat:@"%@ %@ | %@",detailModel.provinceStr,detailModel.cityStr,detailModel.colorName];
    
    self.carCountLalbel.text = [NSString stringWithFormat:@"库存:%ld辆",(long)detailModel.wareStockResponse.stock];
    
    
    NSString *priceStr =
    [NSString stringWithFormat:@"¥%.2f万元",[detailModel.price floatValue]/10000];
//    [NSString stringWithFormat:@"%@万元",detailModel.price];
    self.priceLabel.text = priceStr;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange markRange = [priceStr rangeOfString:@"万元" options:NSCaseInsensitiveSearch];
    
    [attributedString setAttributes:@{NSForegroundColorAttributeName: themeColor,NSFontAttributeName : [UIFont systemFontOfSize:14 weight:UIFontWeightRegular]} range:markRange];
    
    [self.priceLabel setAttributedText:attributedString];
    self.reservePriceLabel.text = [NSString stringWithFormat:@"订金:%@元",detailModel.reservePrice];
    
    [self.updateDateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remarkLabel.mas_bottom);
        make.left.equalTo(self.priceLabel);
        make.height.mas_equalTo(0);
        make.bottom.equalTo(self.contentView).offset(-12).priorityLow();
    }];

//    if (detailModel.updateTime.length > 10) {
//        self.updateDateLabel.text = [NSString stringWithFormat:@"%@更新",[detailModel.updateTime substringToIndex:10]];
//    } else {
//    }
    
    self.remarkLabel.attributedText = [detailModel.remark attributedStringWithLineSpace:6];

//    self.remarkLabel.text = detailModel.remark;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.numberOfLines = 0;
        _nameLabel.preferredMaxLayoutWidth = kScreenWidth - 24;
        _nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }
    return _nameLabel;
}

- (UILabel *)otherInfoLabel{
    if (!_otherInfoLabel) {
        _otherInfoLabel = [[UILabel alloc] init];
        _otherInfoLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _otherInfoLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    }
    return _otherInfoLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
        _priceLabel.textColor = themeColor;
    }
    return _priceLabel;
}

- (UIImageView *)reservePriceBg{
    if (!_reservePriceBg) {
        _reservePriceBg = [[UIImageView alloc] init];
        _reservePriceBg.image = [UIImage imageNamed:@"dinjin_bg"];
        _reservePriceBg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _reservePriceBg;
}

- (UILabel *)reservePriceLabel{
    if (!_reservePriceLabel) {
        _reservePriceLabel = [[UILabel alloc] init];
        _reservePriceLabel.textColor = themeColor;
        _reservePriceLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightThin];
    }
    return _reservePriceLabel;
}

- (UILabel *)updateDateLabel{
    if (!_updateDateLabel) {
        _updateDateLabel = [[UILabel alloc] init];
        _updateDateLabel.preferredMaxLayoutWidth = kScreenWidth - 22;
        _updateDateLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _updateDateLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightThin];
    }
    return _updateDateLabel;
}

//- (UIView *)line{
//    if (!_line) {
//        _line = [[UIView alloc]init];
//        _line.backgroundColor = sectionColor;
//    }
//    return _line;
//}

- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.preferredMaxLayoutWidth = kScreenWidth - 24;
        _remarkLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
    }
    return _remarkLabel;
}

- (UILabel *)carCountLalbel
{
    if (!_carCountLalbel) {
        _carCountLalbel = [[UILabel alloc] init];
        _carCountLalbel.textColor = [UIColor colorWithHexString:@"737373"];
        _carCountLalbel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
        _carCountLalbel.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:_carCountLalbel];
        
        [self.carCountLalbel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.otherInfoLabel.mas_right);
            make.right.equalTo(self.contentView).offset(-12);
            make.top.height.equalTo(self.otherInfoLabel);
        }];
    }
    return _carCountLalbel;
}

@end
