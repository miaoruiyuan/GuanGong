//
//  GGCheckOrderDetailStateCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/12.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckOrderDetailStateCell.h"

@interface GGCheckOrderDetailStateCell ()
@property(nonatomic,strong)UILabel *stateLabel;

@end

NSString * const kCellIdentifierCheckOrderState = @"kGGCheckOrderDetailStateCell";
@implementation GGCheckOrderDetailStateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.stateLabel];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(14);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(18);
        }];

    }
    return self;
}


- (void)setOrderStatus:(CheckOrderStatus)orderStatus{
    switch (orderStatus) {
        case CheckOrderStatusBeContinued:{
            self.stateLabel.text = @"待确认";
        }
            break;
            
        case CheckOrderStatusBePayment:{
            self.stateLabel.text = @"待支付";
        }
            break;

        case CheckOrderStatusBeCheck:{
            self.stateLabel.text = @"待检测";
        }
            break;

        case CheckOrderStatusDone:{
            self.stateLabel.text = @"检测已完成";
        }
            break;
        case CheckOrderStatusClosed:{
            self.stateLabel.text = @"订单已关闭";
        }
            break;

            
        default:
            break;
    }
}


- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _stateLabel.textColor = textNormalColor;
        
    }
    return _stateLabel;
}



@end
