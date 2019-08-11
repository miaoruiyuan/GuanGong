//
//  GGNewCarOrderBaseInfoCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/7/21.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGNewCarOrderBaseInfoCell.h"

NSString * const kGGNewCarOrderBaseInfoCellID = @"GGNewCarOrderBaseInfoCell";

@interface GGNewCarOrderBaseInfoCell ()


@property(nonatomic,strong)UIButton *sellerButton;
@property(nonatomic,strong)UIView *sellerLineView;

@property(nonatomic,strong)UIButton *carInfoButton;


@property(nonatomic,strong)UIImageView *carImageView;
@property(nonatomic,strong)UILabel *carNameLabel;
@property(nonatomic,strong)UILabel *carPriceLabel;
@property(nonatomic,strong)UILabel *tipPriceLabel;

@property(nonatomic,strong)UIView *line3;
@property(nonatomic,strong)UIView *countContentView;

@property(nonatomic,strong)UILabel *countDesLabel;
@property(nonatomic,strong)UIButton *minusBtn;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,strong)UIButton *addBtn;

@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UILabel *contactInfoLabel;
@property(nonatomic,strong)UIView *line2;

@property(nonatomic,strong)UILabel *dealPriceLabel;

@property(nonatomic,strong)GGNewCarDetailModel *carDetailModel;

@property(nonatomic,copy)void(^changeBlock)(NSInteger count);


@property(nonatomic,strong)GGCarOrderDetail *carOrderDetailModel;

@property(nonatomic,copy)void (^carInfoClickedBlock)(GGCarOrderDetail *orderDetail);


@end

@implementation GGNewCarOrderBaseInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
            make.top.equalTo(self.self.carImageView.mas_bottom).offset(12);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(.5);
        }];
        
        [self.contentView addSubview:self.contactInfoLabel];
        [self.contactInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.line.mas_left);
            make.right.equalTo(self.carPriceLabel.mas_right);
            make.top.equalTo(self.line.mas_bottom).offset(18);
        }];
        
        
        [self.contentView addSubview:self.line3];
        
        [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.carImageView.mas_left);
            make.top.equalTo(self.contactInfoLabel.mas_bottom).offset(12);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(.5);
        }];
        
        
        [self.contentView addSubview:self.countDesLabel];
        [self.countDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.carImageView.mas_left);
            make.top.equalTo(self.line3.mas_bottom).offset(13);
        }];
        
        
        [self.contentView addSubview:self.countContentView];
        [self.countContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.countDesLabel);
            make.right.equalTo(self.contentView).offset(-12);
            make.size.mas_equalTo(CGSizeMake(100, 25));
        }];
        
        [self.countContentView addSubview:self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.countContentView);
            make.size.mas_equalTo(CGSizeMake(40, 20));
        }];
        
        [self.countContentView addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.countLabel.mas_right).offset(-7);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.centerY.equalTo(self.countContentView);
        }];
        
        [self.countContentView addSubview:self.minusBtn];
        [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.centerY.equalTo(self.countContentView);
            make.right.equalTo(self.countLabel.mas_left).offset(7);
        }];

        [self.contentView addSubview:self.line2];
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.countDesLabel.mas_bottom).offset(13);
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

- (void)updateUIWithNewCarModel:(GGNewCarDetailModel *)carDetailModel
{
    self.carDetailModel = carDetailModel;
    
    [self.carImageView setImageWithURL:[NSURL URLWithString:carDetailModel.carPhotoUrl] placeholder:[UIImage imageNamed:@"car_detail_image_failed"]];
    self.carNameLabel.text = carDetailModel.titleL;
    NSString *priceStr =
    [NSString stringWithFormat:@"¥%.2f万元",[carDetailModel.price floatValue]/10000];
    self.carPriceLabel.text = priceStr;
    self.contactInfoLabel.text = [NSString stringWithFormat:@"联系方式：%@ %@\n车辆地址：%@",carDetailModel.contactsName,carDetailModel.contactsPhone,carDetailModel.contactsAdds];
    
    NSString *dealPriceStr =
    [NSString stringWithFormat:@"成交价：¥%.2f万",[carDetailModel.dealPrice floatValue]/10000 * carDetailModel.minQuantity];
    self.dealPriceLabel.text = dealPriceStr;
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)carDetailModel.minQuantity];
    
    [self.minusBtn setImage:[UIImage imageNamed:@"new_car_minus_h"] forState:UIControlStateNormal];
    
    if (carDetailModel.minQuantity < self.carDetailModel.wareStockResponse.stock) {
        self.addBtn.enabled = YES;
    }else{
        self.addBtn.enabled = NO;
    }
}

- (void)updateUIWithOrderModel:(GGCarOrderDetail *)orderDetail andCarInfoClicked:(void(^)(GGCarOrderDetail *))block
{
    self.carOrderDetailModel = orderDetail;
    self.carInfoClickedBlock = block;

    self.sellerButton.hidden = NO;
    self.sellerLineView.hidden = NO;
    
    [self.sellerButton setTitle:@"好车抢购" forState:UIControlStateNormal];
    [self.sellerButton setTitleColor:[UIColor colorWithHexString:@"ffa200"] forState:UIControlStateNormal];
    [self.sellerButton setImage:nil forState:UIControlStateNormal];
    [self.sellerButton.titleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightBold]];
    
    [self.carImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(46);
    }];
    
    
    [self.carImageView setImageWithURL:[NSURL URLWithString:orderDetail.car.carPhotoUrl] placeholder:[UIImage imageNamed:@"car_detail_image_failed"]];
    self.carNameLabel.text = orderDetail.car.titleL;
    
    self.carPriceLabel.text = [NSString stringWithFormat:@"¥%.2f万",[orderDetail.car.price floatValue]/10000];

    self.contactInfoLabel.text = [NSString stringWithFormat:@"联系方式：%@ %@\n车辆地址：%@",orderDetail.car.address.contactName,orderDetail.car.address.contactTel,orderDetail.car.address.contactAddress];
    
    self.dealPriceLabel.text = [NSString stringWithFormat:@"成交价：¥%.2f万",[orderDetail.dealPrice floatValue]/10000];
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld辆",orderDetail.carQuantity];
    
    self.countLabel.textAlignment = NSTextAlignmentRight;
    
    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.countContentView);
        make.size.equalTo(self.countContentView);
    }];
    
    self.countContentView.layer.borderColor = [UIColor clearColor].CGColor;
    self.addBtn.hidden = YES;
    self.minusBtn.hidden = YES;
    self.carInfoButton.enabled = YES;
}


- (void)setCountChangeBlock:(void(^)(NSInteger count))block
{
    if (block) {
        self.changeBlock = block;
    }
}

- (void)setCountBtnStatus
{
    NSInteger count = [self.countLabel.text integerValue];
    
    if (count > self.carDetailModel.minQuantity ) {
        [self.minusBtn setImage:[UIImage imageNamed:@"new_car_minus_n"] forState:UIControlStateNormal];
    }else{
        [self.minusBtn setImage:[UIImage imageNamed:@"new_car_minus_h"] forState:UIControlStateNormal];
    }
    
    if (count < self.carDetailModel.wareStockResponse.stock) {
        self.addBtn.enabled = YES;
    }else{
        self.addBtn.enabled = NO;
    }
    
    NSString *dealPriceStr =
    [NSString stringWithFormat:@"成交价:¥%.2f万",[self.carDetailModel.dealPrice floatValue]/10000 * count];
    self.dealPriceLabel.text = dealPriceStr;
    
    if (self.changeBlock) {
        self.changeBlock(count);
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
        
        [self.contentView addSubview:_sellerButton];
        [_sellerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(14);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.height.mas_equalTo(15);
        }];
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
            make.top.equalTo(self.sellerLineView.mas_bottom).offset(1);
            make.bottom.equalTo(self.line.mas_top).offset(-1);
        }];
        
        [[_carInfoButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
            if (self.carInfoClickedBlock) {
                self.carInfoClickedBlock(self.carOrderDetailModel);
            }
        }];
    }
    return _carInfoButton;
}

- (UIView *)sellerLineView{
    if (!_sellerLineView) {
        _sellerLineView = [[UIView alloc] init];
        _sellerLineView.backgroundColor = sectionColor;
        
        [self.contentView addSubview:_sellerLineView];
        [_sellerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sellerButton.mas_bottom).offset(10);
            make.left.equalTo(self.sellerButton.mas_left);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(.5);
        }];
    }
    return _sellerLineView;
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

- (UILabel *)countDesLabel{
    if (!_countDesLabel) {
        _countDesLabel = [[UILabel alloc] init];
        _countDesLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _countDesLabel.font = [UIFont systemFontOfSize:13];
        _countDesLabel.text = @"购买数量";
    }
    return _countDesLabel;
}

- (UIView *)countContentView
{
    if (!_countContentView) {
        _countContentView = [[UIView alloc] init];
        _countContentView.layer.masksToBounds = YES;
        _countContentView.layer.cornerRadius = 2;
        _countContentView.layer.borderWidth = 0.5f;
        _countContentView.layer.borderColor = [UIColor colorWithHexString:@"ededed"].CGColor;
    }
    return _countContentView;
}

- (UIButton *)minusBtn{
    if (!_minusBtn) {
        _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusBtn setImage:[UIImage imageNamed:@"new_car_minus_h"] forState:UIControlStateDisabled];
        [_minusBtn setImage:[UIImage imageNamed:@"new_car_minus_n"] forState:UIControlStateNormal];
        
        @weakify(self);
        [[_minusBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            NSInteger count = [self.countLabel.text integerValue];
            
            if (count <= self.carDetailModel.minQuantity) {
                [MBProgressHUD showError:@"不能小于最低购买量"];
                return;
            }
            
            self.countLabel.text = [NSString stringWithFormat:@"%ld",count - 1];
            [self setCountBtnStatus];
        }];
    }
    return _minusBtn;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _countLabel.font = [UIFont systemFontOfSize:13];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.text = @"1";
    }
    return _countLabel;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage imageNamed:@"new_car_add_h"] forState:UIControlStateDisabled];
        [_addBtn setImage:[UIImage imageNamed:@"new_car_add_n"] forState:UIControlStateNormal];
        @weakify(self);
        [[_addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            NSInteger count = [self.countLabel.text integerValue];
            self.countLabel.text = [NSString stringWithFormat:@"%ld",count + 1];
            [self setCountBtnStatus];
        }];
    }
    return _addBtn;
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
