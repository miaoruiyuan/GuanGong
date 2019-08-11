//
//  GGCheckOrderDetailBaseInfoCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/12.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckOrderDetailBaseInfoCell.h"
#import "FDStackView.h"

@interface GGCheckOrderDetailBaseInfoCell ()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *themeView;
@property(nonatomic,strong)UILabel *companyLabel;
@property(nonatomic,strong)UILabel *areaLabel;
@property(nonatomic,strong)UILabel *carNameLabel;
@property(nonatomic,strong)UILabel *contactLabel;
@property(nonatomic,strong)UIImageView *dottedLine1;
@property(nonatomic,strong)UILabel *stateLabel;

@property(nonatomic,strong)UIImageView *dottedLine2;

@property(nonatomic,strong)UILabel *priceTitleLabel;
@property(nonatomic,strong)UILabel *priceValueLabel;
@property(nonatomic,strong)UILabel *timeTitleLabel;
@property(nonatomic,strong)UILabel *timeValueLabel;
@property(nonatomic,strong)UILabel *addressTitleLabel;
@property(nonatomic,strong)UILabel *addressValueLabel;

@property(nonatomic,strong)UIImageView *dottedLine3;
@property(nonatomic,strong)UILabel *orderNoLabel;
@property(nonatomic,strong)UILabel *creatTimeLabel;
@property(nonatomic,strong)UIImageView *dottedLine4;
@property(nonatomic,strong)UILabel *warnLabel;


@end

NSString * const kCellIdentifierCheckOrderDetailBaseInfo = @"kGGCheckOrderDetailBaseInfoCell";
@implementation GGCheckOrderDetailBaseInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentView.backgroundColor= tableBgColor;
        
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 12, 12, 12));
        }];
        
        [self.bgView addSubview:self.themeView];
        [self.themeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.bgView);
            make.height.mas_equalTo(35);
        }];
        
        [self.themeView addSubview:self.companyLabel];
        [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.themeView.mas_left).offset(15);
            make.centerY.equalTo(self.themeView);
        }];
        
        [self.themeView addSubview:self.areaLabel];
        [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.themeView.mas_right).offset(-10);
            make.centerY.equalTo(self.themeView.mas_centerY);
            make.height.mas_equalTo(16);
        }];
        
        
        [self.bgView addSubview:self.carNameLabel];
        [self.carNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.companyLabel.mas_left);
            make.right.equalTo(self.bgView).offset(-15);
            make.top.equalTo(self.themeView.mas_bottom).offset(15);
        }];
        
        
        [self.bgView addSubview:self.contactLabel];
        [self.contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.carNameLabel.mas_left);
            make.top.equalTo(self.carNameLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(16);
        }];
        
        [self.bgView addSubview:self.dottedLine1];
        [self.dottedLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contactLabel.mas_bottom).offset(15);
            make.left.right.equalTo(self.bgView);
            make.height.mas_equalTo(.5);
        }];
        
        
        [self.bgView addSubview:self.reportButton];
        [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dottedLine1.mas_bottom);
            make.height.mas_equalTo(44);
            make.left.equalTo(self.carNameLabel.mas_left);
            make.right.equalTo(self.bgView.mas_right);
        }];
        
        [self.reportButton addSubview:self.stateLabel];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.reportButton.mas_right).offset(-10);
            make.centerY.equalTo(self.reportButton);
            make.height.mas_equalTo(14);
        }];
        
        [self.bgView addSubview:self.dottedLine2];
        [self.dottedLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reportButton.mas_bottom);
            make.left.right.equalTo(self.bgView);
            make.height.mas_equalTo(.5);
        }];
        
        
        [self.bgView addSubview:self.priceTitleLabel];
        [self.priceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contactLabel.mas_left);
            make.top.equalTo(self.dottedLine2.mas_bottom).offset(15);
            make.height.mas_equalTo(16);
        }];
        
        [self.bgView addSubview:self.priceValueLabel];
        [self.priceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceTitleLabel.mas_right).offset(10);
            make.centerY.equalTo(self.priceTitleLabel);
            make.size.mas_equalTo(CGSizeMake(200, 16));
        }];
        
        [self.bgView addSubview:self.timeTitleLabel];
        [self.timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceTitleLabel);
            make.top.equalTo(self.priceTitleLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(16);
        }];
        
        [self.bgView addSubview:self.timeValueLabel];
        [self.timeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeTitleLabel.mas_right).offset(10);
            make.centerY.equalTo(self.timeTitleLabel);
            make.size.mas_equalTo(CGSizeMake(200, 16));
        }];
        
        
        [self.bgView addSubview:self.addressTitleLabel];
        [self.addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeTitleLabel);
            make.top.equalTo(self.timeTitleLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(16);
        }];
        
        [self.bgView addSubview:self.addressValueLabel];
        [self.addressValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addressTitleLabel);
            make.left.equalTo(self.addressTitleLabel.mas_right).offset(10);
            make.right.equalTo(self.bgView.mas_right).with.offset(-12).priorityLow();
            make.height.mas_greaterThanOrEqualTo(16);
        }];
        
        [self.bgView addSubview:self.dottedLine3];
        [self.dottedLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addressValueLabel.mas_bottom).offset(15);
            make.left.right.equalTo(self.bgView);
            make.height.mas_equalTo(.5);
        }];
        
        [self.bgView addSubview:self.orderNoLabel];
        [self.orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addressTitleLabel.mas_left);
            make.top.equalTo(self.dottedLine3.mas_bottom).offset(15);
            make.height.mas_equalTo(15);
        }];
        
        [self.bgView addSubview:self.creatTimeLabel];
        [self.creatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderNoLabel.mas_left);
            make.top.equalTo(self.orderNoLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(15);
        }];
        
        [self.bgView addSubview:self.dottedLine4];
        [self.dottedLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.creatTimeLabel.mas_bottom).offset(15);
            make.left.right.equalTo(self.bgView);
            make.height.mas_equalTo(.5);
        }];

        [self.bgView addSubview:self.warnLabel];
        [self.warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dottedLine4.mas_bottom).offset(15);
            make.left.equalTo(self.creatTimeLabel);
            make.right.equalTo(self.bgView.mas_right).offset(-12);
//            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
        }];
        
    }
    return self;
}


- (void)setOrderDetail:(GGCheckOrderList *)orderDetail{
    if (_orderDetail != orderDetail) {
        _orderDetail= orderDetail;
        
        self.companyLabel.text = @"好车伯乐检测";
        if (_orderDetail.privinceName) {
            self.areaLabel.text = [NSString stringWithFormat:@"%@ %@",_orderDetail.privinceName,_orderDetail.cityName];
        }
        
        self.carNameLabel.text = [NSString stringWithFormat:@"%@ (%@)",_orderDetail.title,_orderDetail.vin];
        self.contactLabel.text = [NSString stringWithFormat:@"%@  %@",_orderDetail.saleName,_orderDetail.saleTel];
        self.priceValueLabel.text = _orderDetail.price ? _orderDetail.price : @"待确认";
        self.timeValueLabel.text = _orderDetail.checkTime ? _orderDetail.checkTime : @"待确认";
        self.addressValueLabel.text = _orderDetail.address ? _orderDetail.address : @"待确认";
        
        self.orderNoLabel.text = [NSString stringWithFormat:@"订单编号:  %@",_orderDetail.checkOrderNo];
        self.creatTimeLabel.text = [NSString stringWithFormat:@"创建时间:  %@",_orderDetail.createTime];
        
        self.stateLabel.text = _orderDetail.orderStatus == CheckOrderStatusDone ? @"点击查看" : @"未生成";
        
        self.warnLabel.text = @"注意事项\n1、提交订单后，客服将与联系人电话沟通确认具体质检时间、地点及质检价格。\n2、支付成功后开始派单，如超过质检时间还未支付，客服将和你重新确认订单。\n3、如遇其他问题可联系客服进行咨询：400-969-0886\n\n";
    }
}



- (UILabel *)companyLabel{
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _companyLabel.textColor =  [UIColor whiteColor];
    }
    return _companyLabel;
}

- (UILabel *)areaLabel{
    if (!_areaLabel) {
        _areaLabel = [[UILabel alloc]init];
        _areaLabel.textColor = [UIColor whiteColor];
        _areaLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
    }
    return _areaLabel;
}

- (UILabel *)carNameLabel{
    if (!_carNameLabel) {
        _carNameLabel = [[UILabel alloc] init];
        _carNameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _carNameLabel.numberOfLines = 0;
        _carNameLabel.textColor = [UIColor colorWithHexString:@"000000"];
    }
    return _carNameLabel;
}

- (UILabel *)contactLabel{
    if (!_contactLabel) {
        _contactLabel = [[UILabel alloc] init];
        _contactLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _contactLabel.textColor = [UIColor colorWithHexString:@"000000"];
    }
    return _contactLabel;
}

- (UIImageView *)dottedLine1{
    if (!_dottedLine1) {
        _dottedLine1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dottedLine"]];
    }
    return _dottedLine1;
}

- (UIImageView *)dottedLine2{
    if (!_dottedLine2) {
        _dottedLine2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dottedLine"]];
    }
    return _dottedLine2;
}


- (UIButton *)reportButton{
    if (!_reportButton) {
        _reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reportButton setTitle:@"质检报告" forState:UIControlStateNormal];
        [_reportButton.titleLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightBold]];
        [_reportButton setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
        [_reportButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _reportButton;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _stateLabel.textColor = themeColor;
    }
    return _stateLabel;
}

- (UILabel *)priceTitleLabel{
    if (!_priceTitleLabel) {
        _priceTitleLabel = [[UILabel alloc] init];
        _priceTitleLabel.text = @"检测价格";
        _priceTitleLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _priceTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    }
    return _priceTitleLabel;
}

- (UILabel *)priceValueLabel{
    if (!_priceValueLabel) {
        _priceValueLabel = [[UILabel alloc] init];
        _priceValueLabel.textColor = themeColor;
        _priceValueLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    }
    return _priceValueLabel;
}

- (UILabel *)timeTitleLabel{
    if (!_timeTitleLabel) {
        _timeTitleLabel = [[UILabel alloc] init];
        _timeTitleLabel.text = @"检测时间";
        _timeTitleLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _timeTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    }
    return _timeTitleLabel;
}

- (UILabel *)timeValueLabel{
    if (!_timeValueLabel) {
        _timeValueLabel = [[UILabel alloc] init];
        _timeValueLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _timeValueLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    }
    return _timeValueLabel;
}


- (UILabel *)addressTitleLabel{
    if (!_addressTitleLabel) {
        _addressTitleLabel = [[UILabel alloc] init];
        _addressTitleLabel.text = @"检测地点";
        _addressTitleLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _addressTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    }
    return _addressTitleLabel;
}

- (UILabel *)addressValueLabel{
    if (!_addressValueLabel) {
        _addressValueLabel = [[UILabel alloc] init];
        _addressValueLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _addressValueLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        _addressValueLabel.numberOfLines = 0;
    }
    return _addressValueLabel;
}



- (UIImageView *)dottedLine3{
    if (!_dottedLine3) {
        _dottedLine3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dottedLine"]];
    }
    return _dottedLine3;
}

- (UILabel *)orderNoLabel{
    if (!_orderNoLabel) {
        _orderNoLabel = [[UILabel alloc] init];
        _orderNoLabel.textColor = [UIColor colorWithHexString:@"9e9e9e"];
        _orderNoLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
    }
    return _orderNoLabel;
}

- (UILabel *)creatTimeLabel{
    if (!_creatTimeLabel) {
        _creatTimeLabel = [[UILabel alloc] init];
        _creatTimeLabel.textColor = [UIColor colorWithHexString:@"9e9e9e"];
        _creatTimeLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
    }
    return _creatTimeLabel;
}

- (UIImageView *)dottedLine4{
    if (!_dottedLine4) {
        _dottedLine4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dottedLine"]];
    }
    return _dottedLine4;
}

- (UILabel *)warnLabel{
    if (!_warnLabel) {
        _warnLabel = [[UILabel alloc] init];
        _warnLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _warnLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
        _warnLabel.numberOfLines = 0;
    }
    return _warnLabel;
}




- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 6.0;
    }
    return _bgView;
}

- (UIView *)themeView{
    if (!_themeView) {
        _themeView =[[UIView alloc] init];
        _themeView.backgroundColor = [UIColor colorWithHexString:@"14b2e6"];
    }
    return _themeView;
}




@end
