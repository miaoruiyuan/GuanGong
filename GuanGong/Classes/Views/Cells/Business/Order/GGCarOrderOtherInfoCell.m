//
//  GGCarOrderOtherInfoCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/30.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarOrderOtherInfoCell.h"
#import "FDStackView.h"

@interface GGCarOrderOtherInfoCell ()

@property(nonatomic,strong)FDStackView *leftStackView;
@property(nonatomic,strong)FDStackView *rightStackView;

@end

NSString * const kCellIdentifierCarOrderOtherInfo = @"kGGCarOrderOtherInfoCell";

@implementation GGCarOrderOtherInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.leftStackView];
        [self.leftStackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(12);
            make.left.equalTo(self.contentView.mas_left).offset(14);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
            make.width.mas_offset(100);
        }];
        
        [self.contentView addSubview:self.rightStackView];
        [self.rightStackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.leftStackView);
            make.left.equalTo(self.leftStackView.mas_right);
            make.right.equalTo(self.contentView.mas_right).offset(-14);
        }];
    }
    return self;
}

- (void)setOrderDetail:(GGCarOrderDetail *)orderDetail
{
    _orderDetail = orderDetail;

//    NSMutableArray *mArr = [NSMutableArray arrayWithObjects:_orderDetail.orderNo,_orderDetail.createTimeStr, nil];
    
    NSArray *dataArray = nil;
    NSArray *titleArray = nil;
//  @[@"订单编号",@"创建时间",@"支付订金",@"支付尾款",@"确认收货"];

    if (orderDetail.status == CarOrderStatusCJDD){
        titleArray = @[@"订单编号",@"创建时间"];
        dataArray = @[_orderDetail.orderNo,_orderDetail.createTimeStr];
    }else if (orderDetail.status == CarOrderStatusZFDJ){
        titleArray = @[@"订单编号",@"创建时间",@"支付订金"];
        dataArray = @[_orderDetail.orderNo,_orderDetail.createTimeStr,_orderDetail.reservePriceDate];
    }else if (orderDetail.status == CarOrderStatusYFH){
        titleArray = @[@"订单编号",@"创建时间",@"支付订金",@"支付尾款"];
        dataArray = @[_orderDetail.orderNo,_orderDetail.createTimeStr,_orderDetail.reservePriceDate,_orderDetail.finalPriceDate];
    }else if (orderDetail.status == CarOrderStatusJYWC){
        titleArray = @[@"订单编号",@"创建时间",@"支付订金",@"支付尾款",@"确认收货"];
        
        NSString *finalPriceDate = @"";
        if (_orderDetail.finalPriceDate) {
            finalPriceDate = _orderDetail.finalPriceDate;
        }
        
        dataArray = @[_orderDetail.orderNo,_orderDetail.createTimeStr,_orderDetail.reservePriceDate,finalPriceDate,_orderDetail.tranEndDate];
    }else {
        if (orderDetail.finalPriceDate.length > 0) {
            titleArray = @[@"订单编号",@"创建时间",@"支付订金",@"支付尾款"];
            dataArray = @[_orderDetail.orderNo,_orderDetail.createTimeStr,_orderDetail.reservePriceDate,_orderDetail.finalPriceDate];
        }else if (_orderDetail.reservePriceDate.length > 0) {
            titleArray = @[@"订单编号",@"创建时间",@"支付订金"];
            dataArray = @[_orderDetail.orderNo,_orderDetail.createTimeStr,_orderDetail.reservePriceDate];
        } else {
            titleArray = @[@"订单编号",@"创建时间"];
            dataArray = @[_orderDetail.orderNo,_orderDetail.createTimeStr];
        }
    }
    
    for (UILabel *label in self.leftStackView.arrangedSubviews) {
        [self.leftStackView removeArrangedSubview:label];
    }
    
    for (UILabel *label in self.rightStackView.arrangedSubviews) {
        [self.rightStackView removeArrangedSubview:label];
    }
    
    for (int i = 0; i < titleArray.count; i ++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArray[i];
        titleLabel.textColor = textLightColor;
        titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightThin];
        [self.leftStackView addArrangedSubview:titleLabel];
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.text = dataArray[i];
        valueLabel.textColor = textLightColor;
        valueLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightThin];
        [self.rightStackView addArrangedSubview:valueLabel];
    }
}

- (FDStackView *)leftStackView{
    if (!_leftStackView) {
        _leftStackView = [[FDStackView alloc] initWithArrangedSubviews:@[]];
        _leftStackView.translatesAutoresizingMaskIntoConstraints = NO;
        _leftStackView.axis = UILayoutConstraintAxisVertical;
        _leftStackView.distribution = UIStackViewDistributionFillEqually;
        _leftStackView.alignment = UIStackViewAlignmentFill;
        _leftStackView.spacing = 4;
    }
    return _leftStackView;
}

- (FDStackView *)rightStackView{
    if (!_rightStackView) {
        _rightStackView = [[FDStackView alloc] initWithArrangedSubviews:@[]];
        _rightStackView.translatesAutoresizingMaskIntoConstraints = NO;
        _rightStackView.axis = UILayoutConstraintAxisVertical;
        _rightStackView.distribution = UIStackViewDistributionFillEqually;
        _rightStackView.alignment = UIStackViewAlignmentTrailing;
        _rightStackView.spacing = 4;
    }
    return _rightStackView;
}

@end
