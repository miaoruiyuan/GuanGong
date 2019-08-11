//
//  GGCarOrderBaseInfoCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarOrderBaseInfoCell.h"

@interface GGCarOrderBaseInfoCell ()

@property(nonatomic,strong)UIButton *sellerButton;
@property(nonatomic,strong)UIView *line3;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIImageView *carImageView;
@property(nonatomic,strong)UILabel *carNameLabel;
@property(nonatomic,strong)UILabel *carPriceLabel;
@property(nonatomic,strong)UILabel *tipPriceLabel;
@property(nonatomic,strong)UILabel *contactInfoLabel;
@property(nonatomic,strong)UIView *line2;
@property(nonatomic,strong)UILabel *dealPriceLabel;
@property(nonatomic,strong)UIButton *carInfoButton;

@property(nonatomic,copy)void (^carInfoClickedBlock)(GGCarOrderDetail *orderDetail);

@end

NSString * const kCellIdentifierCarOrderBaseInfo = @"kGGCarOrderBaseInfoCell";

@implementation GGCarOrderBaseInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.sellerButton];
        [self.sellerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(14);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.height.mas_equalTo(15);
        }];
    
        [self.contentView addSubview:self.line3];
        [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sellerButton.mas_bottom).offset(10);
            make.left.equalTo(self.sellerButton.mas_left);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(.5);
        }];

        [self.contentView addSubview:self.carImageView];
        [self.carImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(14);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(72, 54));
        }];
        
        [self.contentView addSubview:self.carNameLabel];
        [self.carNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.carImageView.mas_right).offset(14);
            make.centerY.equalTo(self.carImageView);
        }];
        
        [self.contentView addSubview:self.carPriceLabel];
        [self.carPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-12);
            make.centerY.equalTo(self.carNameLabel.mas_centerY).offset(-7);
            make.left.equalTo(self.carNameLabel.mas_right).offset(10).priorityHigh();
            make.width.mas_greaterThanOrEqualTo(82);
        }];
        
        [self.contentView addSubview:self.tipPriceLabel];
        [self.tipPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.carPriceLabel.mas_bottom).offset(6);
            make.right.equalTo(self.carPriceLabel.mas_right);
            make.size.mas_equalTo(CGSizeMake(56, 15));
        }];
        
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.carImageView.mas_left);
            make.top.equalTo(self.carImageView.mas_bottom).offset(12);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(.5);
        }];
        
        [self.contentView addSubview:self.contactInfoLabel];
        [self.contactInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.line.mas_left);
            make.right.equalTo(self.carPriceLabel.mas_right);
            make.top.equalTo(self.line.mas_bottom).offset(18);
        }];
        
        [self.contentView addSubview:self.line2];
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contactInfoLabel.mas_bottom).offset(18);
            make.left.equalTo(self.contactInfoLabel);
            make.right.equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(.5);
        }];
        
        [self.contentView addSubview:self.dealPriceLabel];
        [self.dealPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contactInfoLabel.mas_right);
            make.top.equalTo(self.line2.mas_bottom).offset(12);
            make.height.mas_equalTo(15);
        }];
    }
    return self;
}

- (void)updateUIWithOrderModel:(GGCarOrderDetail *)orderDetail andCarInfoClicked:(void(^)(GGCarOrderDetail *))block
{
    self.carInfoClickedBlock = block;
    self.orderDetail = orderDetail;
}

- (void)updateUIWithNewCarModel:(GGNewCarDetailModel *)carDetailModel
{
    self.sellerButton.hidden = YES;
    self.line3.hidden = YES;
    
    [self.carImageView setImageWithURL:[NSURL URLWithString:carDetailModel.carPhotoUrl] placeholder:[UIImage imageNamed:@"car_detail_image_failed"]];
    self.carNameLabel.text = carDetailModel.titleL;
    NSString *priceStr =
    [NSString stringWithFormat:@"¥%.2f万元",[carDetailModel.price floatValue]/10000];
    self.carPriceLabel.text = priceStr;
    self.contactInfoLabel.text = [NSString stringWithFormat:@"联系方式：%@ %@\n车辆地址：%@",carDetailModel.contactsName,carDetailModel.contactsPhone,carDetailModel.contactsAdds];
    
    NSString *dealPriceStr =
    [NSString stringWithFormat:@"成交价：¥%.2f万",[carDetailModel.dealPrice floatValue]/10000];
    self.dealPriceLabel.text = dealPriceStr;
}

- (void)setOrderDetail:(GGCarOrderDetail *)orderDetail{
    
    _orderDetail = orderDetail;

    self.sellerButton.hidden = NO;
    self.line3.hidden = NO;
    self.carInfoButton.enabled = YES;

    [self.carImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(46);
    }];
    
    if (_orderDetail.car.carType == 1) {
        [self.sellerButton setTitle:@"好车抢购" forState:UIControlStateNormal];
        [self.sellerButton setTitleColor:[UIColor colorWithHexString:@"ffa200"] forState:UIControlStateNormal];
        [self.sellerButton setImage:nil forState:UIControlStateNormal];
        [self.sellerButton.titleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightBold]];

    }else{
        
        [self.sellerButton setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
        [self.sellerButton setImage:[UIImage imageNamed:@"arrow_right_small"] forState:UIControlStateNormal];
        [self.sellerButton.titleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightLight]];
        [self.sellerButton putImageOnTheRightSideOfTitle];
        
        //    如果当年卖家ID是自己,则显示买家名字
        if ([_orderDetail.saleId isEqualToNumber:[GGLogin shareUser].user.userId]) {
            [self.sellerButton setTitle:[NSString stringWithFormat:@"买家:%@",_orderDetail.buyerName] forState:UIControlStateNormal];
        } else {
            [self.sellerButton setTitle:[NSString stringWithFormat:@"卖家:%@",_orderDetail.saleName] forState:UIControlStateNormal];
        }
    }
    
    self.dealPriceLabel.text = [NSString stringWithFormat:@"成交价: ¥%.2f万",[_orderDetail.dealPrice floatValue]/10000];
    
    [self setCar:_orderDetail.car];
}

- (void)setCar:(GGCar *)car{
    _car = car;
    
    [self.carImageView setImageWithURL:[NSURL URLWithString:_car.carPhotoUrl] placeholder:[UIImage imageNamed:@"car_detail_image_failed"]];
    self.carNameLabel.text = _car.titleL;
    
    self.contactInfoLabel.text = [NSString stringWithFormat:@"联系方式：%@ %@\n车辆地址：%@",_car.address.contactName,_car.address.contactTel,_car.address.contactAddress];

    if (!_orderDetail) {
        self.dealPriceLabel.text = [NSString stringWithFormat:@"成交价: ¥%.2f万",[_car.price floatValue]/10000];
        self.sellerButton.hidden = YES;
        self.line3.hidden = YES;
    }else{
        self.carPriceLabel.text = [NSString stringWithFormat:@"¥%.2f万",[_car.price floatValue]/10000];
    }
}

#pragma mark - init Views

- (UIButton *)sellerButton{
    if (!_sellerButton) {
        _sellerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sellerButton setTitle:@"卖家: " forState:UIControlStateNormal];
        [_sellerButton setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
        [_sellerButton setImage:[UIImage imageNamed:@"arrow_right_small"] forState:UIControlStateNormal];
        [_sellerButton.titleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightLight]];
        [_sellerButton putImageOnTheRightSideOfTitle];
    }
    return _sellerButton;
}

- (UIButton *)carInfoButton{
    if (!_carInfoButton) {
        _carInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carInfoButton setImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self.contentView insertSubview:_carInfoButton belowSubview:self.carImageView];
        [_carInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.line3.mas_bottom).offset(1);
            make.bottom.equalTo(self.line.mas_top).offset(-1);
        }];
        
        [[_carInfoButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
            if (self.carInfoClickedBlock) {
                self.carInfoClickedBlock(self.orderDetail);
            }
        }];
    }
    return _carInfoButton;
}

- (UIView *)line3{
    if (!_line3) {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = sectionColor;
    }
    return _line3;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = sectionColor;
    }
    return _line;
}

- (UIImageView *)carImageView{
    if (!_carImageView) {
        _carImageView =[[UIImageView alloc] init];
        _carImageView.contentMode = UIViewContentModeScaleAspectFill;
        _carImageView.clipsToBounds = YES;
    }
    return _carImageView;
}

- (UILabel *)carNameLabel{
    if (!_carNameLabel) {
        _carNameLabel = [[UILabel alloc] init];
        _carNameLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _carNameLabel.font = [UIFont systemFontOfSize:14];
        _carNameLabel.numberOfLines = 0;
    }
    return _carNameLabel;
}

- (UILabel *)carPriceLabel{
    if (!_carPriceLabel) {
        _carPriceLabel = [[UILabel alloc] init];
        _carPriceLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _carPriceLabel.font = [UIFont systemFontOfSize:14];
        _carPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _carPriceLabel;
}

- (UILabel *)tipPriceLabel{
    if (!_tipPriceLabel) {
        _tipPriceLabel = [[UILabel alloc] init];
        _tipPriceLabel.text = @"资金担保";
        _tipPriceLabel.textColor = [UIColor orangeColor];
        _tipPriceLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
        _tipPriceLabel.textAlignment = NSTextAlignmentCenter;
        _tipPriceLabel.layer.masksToBounds = YES;
        _tipPriceLabel.layer.cornerRadius = 4.f;
        _tipPriceLabel.layer.borderWidth = .7;
        _tipPriceLabel.layer.borderColor = [UIColor orangeColor].CGColor;
    }
    return _tipPriceLabel;
}

- (UILabel *)contactInfoLabel{
    if (!_contactInfoLabel) {
        _contactInfoLabel = [[UILabel alloc] init];
        _contactInfoLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _contactInfoLabel.font = [UIFont systemFontOfSize:13];
        _contactInfoLabel.numberOfLines = 0;
    }
    return _contactInfoLabel;
}

- (UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = sectionColor;
    }
    return _line2;
}

- (UILabel *)dealPriceLabel{
    if (!_dealPriceLabel) {
        _dealPriceLabel = [[UILabel alloc] init];
        _dealPriceLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _dealPriceLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        _dealPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dealPriceLabel;
}

@end
