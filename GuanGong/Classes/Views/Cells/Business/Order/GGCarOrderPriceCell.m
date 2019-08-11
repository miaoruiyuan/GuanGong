//
//  GGCarOrderPriceCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarOrderPriceCell.h"
#import "GGOrderDepositAlertView.h"

@interface GGCarOrderPriceCell ()

@property(nonatomic,strong)UILabel *dinjinTitleLabel;
@property(nonatomic,strong)UILabel *dinjinValueLabel;

@property(nonatomic,strong)UILabel *weikuanTitleLabel;
@property(nonatomic,strong)UILabel *weikuanValueLabel;

@property(nonatomic,strong)UIButton *showTipBtn;


@end

NSString * const kCellIdentifierCarOrderPrice = @"kGGCarOrderPriceCell";
@implementation GGCarOrderPriceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.dinjinTitleLabel];
        [self.dinjinTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(14);
            make.size.mas_equalTo(CGSizeMake(50, 17));
        }];
        
        [self.contentView addSubview:self.dinjinValueLabel];
        [self.dinjinValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-14);
            make.centerY.height.equalTo(self.dinjinTitleLabel);
        }];
        
        [self.contentView addSubview:self.weikuanTitleLabel];
        [self.weikuanTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.width.equalTo(self.dinjinTitleLabel);
            make.top.equalTo(self.dinjinTitleLabel.mas_bottom).offset(10);
        }];
        
        [self.contentView addSubview:self.weikuanValueLabel];
        [self.weikuanValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.dinjinValueLabel);
            make.right.equalTo(self.contentView.mas_right).offset(-14);
            make.centerY.equalTo(self.weikuanTitleLabel);
        }];
    }
    return self;
}

- (void)setCar:(GGCar *)car{
    _car = car;
    self.dinjinValueLabel.text = [NSString stringWithFormat:@"¥%@",_car.reservePrice];
    self.weikuanValueLabel.text = [NSString stringWithFormat:@"¥%.2f",[_car.price floatValue] - [_car.reservePrice floatValue]];
    [[[self.showTipBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(UIButton *sender) {
        [GGOrderDepositAlertView showContent:@"定金为车款的一部分，支付定金后对车辆不满意可以申请退定金。" andBlock:nil];
    }];;
}

- (void)showUIWithReservePrice:(NSString *)reservePrice finalPrice:(NSString *)finalPrice;
{
    self.dinjinValueLabel.text = [NSString stringWithFormat:@"¥%@",reservePrice];
    self.weikuanValueLabel.text = [NSString stringWithFormat:@"¥%@",finalPrice];
}

- (void)setOrderDetail:(GGCarOrderDetail *)orderDetail
{
    _orderDetail = orderDetail;
    
    self.dinjinValueLabel.text = [NSString stringWithFormat:@"¥%@",_orderDetail.reservePrice];
    self.weikuanValueLabel.text = [NSString stringWithFormat:@"¥%@",_orderDetail.finalPrice];
    
    if (_orderDetail.status ==   CarOrderStatusCJDD) {
        self.dinjinTitleLabel.textColor = themeColor;
        self.dinjinValueLabel.textColor = themeColor;
        self.weikuanTitleLabel.textColor = [UIColor blackColor];
        self.weikuanValueLabel.textColor = [UIColor blackColor];
    }else if(_orderDetail.status ==  CarOrderStatusZFDJ){
        self.dinjinTitleLabel.textColor = [UIColor blackColor];
        self.dinjinValueLabel.textColor = [UIColor blackColor];
        self.weikuanTitleLabel.textColor = themeColor;
        self.weikuanValueLabel.textColor = themeColor;
    }else{
        self.dinjinTitleLabel.textColor = [UIColor blackColor];
        self.dinjinValueLabel.textColor = [UIColor blackColor];
        self.weikuanTitleLabel.textColor = [UIColor blackColor];
        self.weikuanValueLabel.textColor = [UIColor blackColor];
    }
}

- (UILabel *)dinjinTitleLabel{
    if (!_dinjinTitleLabel) {
        _dinjinTitleLabel = [[UILabel alloc] init];
        _dinjinTitleLabel.text = @"订金";
        _dinjinTitleLabel.textColor = themeColor;
        _dinjinTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _dinjinTitleLabel;
}

- (UILabel *)dinjinValueLabel{
    if (!_dinjinValueLabel) {
        _dinjinValueLabel = [[UILabel alloc] init];
        _dinjinValueLabel.textColor = themeColor;
        _dinjinValueLabel.font = [UIFont systemFontOfSize:14];
        _dinjinValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dinjinValueLabel;
}


- (UILabel *)weikuanTitleLabel{
    if (!_weikuanTitleLabel) {
        _weikuanTitleLabel = [[UILabel alloc] init];
        _weikuanTitleLabel.text = @"尾款";
        _weikuanTitleLabel.textColor = [UIColor blackColor];
        _weikuanTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _weikuanTitleLabel;
}

- (UILabel *)weikuanValueLabel{
    if (!_weikuanValueLabel) {
        _weikuanValueLabel = [[UILabel alloc] init];
        _weikuanValueLabel.textColor = [UIColor blackColor];
        _weikuanValueLabel.font = [UIFont systemFontOfSize:14];
        _weikuanValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _weikuanValueLabel;
}


- (UIButton *)showTipBtn
{
    if (!_showTipBtn) {
        _showTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showTipBtn setImage:[UIImage imageNamed:@"moeny_notifa_icon"] forState:UIControlStateNormal];
        [self.contentView addSubview:_showTipBtn];
        [_showTipBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-4);
            make.centerY.equalTo(self.dinjinValueLabel);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [self.dinjinValueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-34);
        }];
    }
    return _showTipBtn;
}


@end
