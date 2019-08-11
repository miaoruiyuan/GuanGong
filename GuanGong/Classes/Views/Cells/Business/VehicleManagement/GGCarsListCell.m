//
//  GGCarsListCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarsListCell.h"
#import "TTTAttributedLabel.h"

@interface GGCarsListCell ()

@property(nonatomic,strong)UIImageView *carImageView;
@property(nonatomic,strong)UILabel *carNameLabel;
@property(nonatomic,strong)UILabel *otherInfoLabel;
@property(nonatomic,strong)TTTAttributedLabel *priceLabel;
@end

NSString *const kCellIdentifierCarsList = @"kGGCarsListCell";
@implementation GGCarsListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *cellBg = [[UIView alloc] init];
        cellBg.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"]; // this RGB value for blue color 5b61f3
        cellBg.layer.masksToBounds = YES;
        self.selectedBackgroundView = cellBg;
        
        
        [self.contentView addSubview:self.carImageView];
        [self.carImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(14);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10).priority(710);
            make.size.mas_equalTo(CGSizeMake(105, 79));
        }];
        
        
        [self.contentView addSubview:self.carNameLabel];
        [self.carNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.carImageView.mas_right).offset(12);
            make.top.equalTo(self.carImageView.mas_top);
            make.right.equalTo(self.contentView.mas_right).offset(-12);
        }];
        
        [self.contentView addSubview:self.otherInfoLabel];
        [self.otherInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.carNameLabel);
            make.top.equalTo(self.carNameLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(15);
        }];
        
        
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.otherInfoLabel);
            make.bottom.equalTo(self.carImageView);
            make.height.mas_equalTo(15);
        }];
        
    }
    return self;
}

- (void)setCar:(GGVehicleList *)car{
    if (_car != car) {
        _car = car;
    
        [self.carImageView setImageWithURL:[NSURL URLWithString:_car.carPhotoUrl]
                                  placeholder:[UIImage imageNamed:@"car_detail_image_failed"]
                                      options:YYWebImageOptionShowNetworkActivity|YYWebImageOptionProgressive| YYWebImageOptionProgressiveBlur
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         
                                     }
                                    transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                                        image = [image imageByResizeToSize:CGSizeMake(105, 79) contentMode:UIViewContentModeScaleAspectFill];
                                        return [image imageByRoundCornerRadius:2];
                                    }
                                   completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                       
                                   }];
        
        self.carNameLabel.text = _car.titleM;
        self.otherInfoLabel.text = [NSString stringWithFormat:@"%@万公里 | %@上牌",_car.km,_car.firstRegDate];
        self.priceLabel.text = [NSString stringWithFormat:@"%.2f万元",[_car.price floatValue]/10000];
    }
}

- (UIImageView *)carImageView{
    if (!_carImageView) {
        _carImageView = [[UIImageView alloc] init];
    }
    return _carImageView;
}

- (UILabel *)carNameLabel{
    if (!_carNameLabel) {
        _carNameLabel = [[UILabel alloc] init];
        _carNameLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _carNameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _carNameLabel.highlightedTextColor  = [UIColor whiteColor];
        _carNameLabel.numberOfLines = 0;
    }
    return _carNameLabel;
}

- (UILabel *)otherInfoLabel{
    if (!_otherInfoLabel) {
        _otherInfoLabel = [UILabel new];
        _otherInfoLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
        _otherInfoLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _otherInfoLabel.highlightedTextColor = [UIColor whiteColor];
    }
    return _otherInfoLabel;
}


- (TTTAttributedLabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [TTTAttributedLabel new];
        _priceLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _priceLabel.textColor = themeColor;
        _priceLabel.highlightedTextColor = [UIColor whiteColor];
    }
    return _priceLabel;
}


@end
