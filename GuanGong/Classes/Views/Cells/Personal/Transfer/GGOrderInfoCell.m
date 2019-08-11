//
//  GGOrderInfoCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOrderInfoCell.h"

@interface GGOrderInfoCell ()

@property(nonatomic,strong)UILabel *orderNoLabel;
@property(nonatomic,strong)UILabel *creatTimeLabel;


@end

NSString * const kCellIdentifierOrderInfo = @"kGGOrderInfoCell";
@implementation GGOrderInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.orderNoLabel];
        [self.contentView addSubview:self.creatTimeLabel];
        
        
        [self.orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(12);
            make.left.equalTo(self.contentView.mas_left).with.offset(kLeftPadding);
            make.height.mas_equalTo(14);
        }];
        
        
        [self.creatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderNoLabel);
            make.top.equalTo(self.orderNoLabel.mas_bottom).with.offset(6);
            make.height.equalTo(self.orderNoLabel);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-12).priority(710);
        }];
        
        
        
        
    }
    return self;
}



- (void)setOrderDetails:(GGOrderDetails *)orderDetails{
    if (_orderDetails != orderDetails) {
        _orderDetails = orderDetails;
        
        self.orderNoLabel.text = [NSString stringWithFormat:@"订单编号:%@",_orderDetails.orderNo];
        self.creatTimeLabel.text = [NSString stringWithFormat:@"创建时间:%@",[NSDate dateWithTimeIntreval:_orderDetails.createOrderTime]];
        
    }
}


- (UILabel *)orderNoLabel{
    if (!_orderNoLabel) {
        _orderNoLabel = [[UILabel alloc]init];
        _orderNoLabel.textColor = textLightColor;
        _orderNoLabel.font = [UIFont systemFontOfSize:12];
    }
    return _orderNoLabel;
}


- (UILabel *)creatTimeLabel{
    if (!_creatTimeLabel) {
        _creatTimeLabel = [[UILabel alloc] init];
        _creatTimeLabel.textColor = textLightColor;
        _creatTimeLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _creatTimeLabel;
}



@end
