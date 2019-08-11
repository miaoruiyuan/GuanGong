//
//  GGCarOrderListCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarOrderListCell.h"

@interface GGCarOrderListCell ()

@property(nonatomic,strong)UIButton *sellerButton;
@property(nonatomic,strong)UILabel *stateLabel;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIImageView *carImageView;
@property(nonatomic,strong)UILabel *carNameLabel;
@property(nonatomic,strong)UILabel *carPriceLabel;
@property(nonatomic,strong)UIView *line2;
@property(nonatomic,strong)UILabel *totalPriceLabel;

@property(nonatomic,strong)UIButton *functionButton;

@property(nonatomic,strong)MASConstraint *totalPriceLabelConstraint;

@end

NSString * const kCellIdentifierCarOrderList = @"kGGCarOrderListCell";

@implementation GGCarOrderListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.sellerButton];
        [self.sellerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(14);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.height.mas_equalTo(15);
        }];
        
        [self.contentView addSubview:self.stateLabel];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-14);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.height.mas_equalTo(15);
        }];
        
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sellerButton.mas_bottom).offset(10);
            make.left.equalTo(self.sellerButton.mas_left);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(.5);
        }];
        
        [self.contentView addSubview:self.carImageView];
        [self.carImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.line);
            make.top.equalTo(self.line.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(74, 54));
        }];
        
        
        [self.contentView addSubview:self.carNameLabel];
        [self.carNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.carImageView.mas_right).offset(12);
            make.centerY.equalTo(self.carImageView);
        }];
        
        [self.contentView addSubview:self.carPriceLabel];
        [self.carPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.stateLabel.mas_right);
            make.left.equalTo(self.carNameLabel.mas_right).offset(12);
            make.centerY.equalTo(self.carNameLabel);
            make.width.mas_greaterThanOrEqualTo(70);
        }];
        
        [self.contentView addSubview:self.line2];
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.carImageView.mas_bottom).offset(10);
            make.left.right.equalTo(self.line);
            make.height.mas_equalTo(.5);
        }];
        
        [self.contentView addSubview:self.functionButton];
        [self.functionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line2.mas_bottom).offset(12);
            make.right.equalTo(self.contentView.mas_right).offset(-12);
            make.size.mas_offset(CGSizeMake(70, 25));
        }];
        
        [self.contentView addSubview:self.totalPriceLabel];
        [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            self.totalPriceLabelConstraint =  make.right.equalTo(self.functionButton.mas_left).offset(-10);
            make.centerY.equalTo(self.functionButton);
            make.height.mas_equalTo(15);
        }];
    }
    return self;
}

- (void)setOrderDetail:(GGCarOrderDetail *)orderDetail{
    _orderDetail  = orderDetail;

    if (_orderDetail.car.carType == 1) {
        [self.sellerButton setTitle:@"好车抢购" forState:UIControlStateNormal];
        [self.sellerButton setTitleColor:[UIColor colorWithHexString:@"ffa200"] forState:UIControlStateNormal];
        [self.sellerButton setImage:nil forState:UIControlStateNormal];
        [self.sellerButton.titleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightBold]];
    }else{
        
        [self.sellerButton setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
        [self.sellerButton.titleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightLight]];
        [self.sellerButton setImage:[UIImage imageNamed:@"arrow_right_small"] forState:UIControlStateNormal];
        [self.sellerButton putImageOnTheRightSideOfTitle];
        //如果当年卖家ID是自己,则显示买家名字
        if ([_orderDetail.saleId isEqualToNumber:[GGLogin shareUser].user.userId]) {
            [self.sellerButton setTitle:[NSString stringWithFormat:@"买家:%@",_orderDetail.buyerName] forState:UIControlStateNormal];
        }else{
            [self.sellerButton setTitle:[NSString stringWithFormat:@"卖家:%@",_orderDetail.saleName] forState:UIControlStateNormal];
        }
    }
    
    NSString *statusName = _orderDetail.statusName;
    if (_orderDetail.hasPayAnother) {
        statusName = [NSString stringWithFormat:@"%@(代付)",statusName];
    }
    self.stateLabel.text = statusName;
        
    [self.carImageView setImageWithURL:[NSURL URLWithString:_orderDetail.car.carPhotoUrl]
                              placeholder:[UIImage imageNamed:@"car_detail_image_failed"]
                                  options:YYWebImageOptionAllowInvalidSSLCertificates
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     
                                 }
                                transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                                    return [image imageByResizeToSize:CGSizeMake(72, 54) contentMode:UIViewContentModeScaleAspectFill];
                                }
                               completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                   
                               }];
    
    self.carNameLabel.text = _orderDetail.car.titleL;
    self.carPriceLabel.text = [NSString stringWithFormat:@"¥%.2f万",[_orderDetail.car.price floatValue]/10000];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"成交价: %.2f万",[_orderDetail.dealPrice floatValue]/10000];
    
    NSString *title = nil;
    NSNumber *userID = [GGLogin shareUser].user.userId;

    switch (_orderDetail.status) {
        case CarOrderStatusCJDD:{
            if ([_orderDetail.saleId isEqualToNumber:userID]) {
                title = @"修改价格";
            }else{
                if (_orderDetail.hasPayAnother){
                    title = @"取消代付";
                }else{
                    title = @"支付订金";
                }
            }
        }
            break;
            
        case CarOrderStatusZFDJ:
            if (![_orderDetail.saleId isEqualToNumber:userID]) {
                if (_orderDetail.hasPayAnother){
                    title = @"取消代付";
                }else{
                    title = @"支付尾款";
                }
            }
            break;
            
        case CarOrderStatusYFH:
            if (![_orderDetail.saleId isEqualToNumber:userID]) {
                title = @"确认收货";
            }

            break;
            
        default:
            break;
    }
    
    [self.totalPriceLabelConstraint uninstall];
    if (title) {
        [self.functionButton setTitle:title forState:UIControlStateNormal];
        self.functionButton.hidden = NO;
        [self.totalPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            self.totalPriceLabelConstraint =  make.right.equalTo(self.functionButton.mas_left).offset(-10);
        }];
    }else{
        self.functionButton.hidden = YES;
        [self.totalPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            self.totalPriceLabelConstraint =  make.right.equalTo(self.contentView.mas_right).offset(-12);
        }];
    }
}

#pragma mark - init view

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

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
        _stateLabel.textColor = themeColor;
        _stateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _stateLabel;
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
        _carPriceLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _carPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _carPriceLabel;
}


- (UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = sectionColor;
    }
    return _line2;
}

- (UILabel *)totalPriceLabel{
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
        _totalPriceLabel.textColor = [UIColor colorWithHexString:@"000000"];
    }
    return _totalPriceLabel;
}

- (UIButton *)functionButton{
    if (!_functionButton) {
        _functionButton = [[UIButton alloc] init];
        [_functionButton setTitleColor:themeColor forState:UIControlStateNormal];
        [_functionButton.titleLabel setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightLight]];
        _functionButton.layer.masksToBounds = YES;
        _functionButton.layer.cornerRadius = 4;
        _functionButton.layer.borderWidth = .8;
        _functionButton.layer.borderColor = themeColor.CGColor;
        [[_functionButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
            
            if (self.functionButtonBlock) {
                self.functionButtonBlock([x titleForState:UIControlStateNormal]);
            }
        }];
    }
    return _functionButton;
}

@end
