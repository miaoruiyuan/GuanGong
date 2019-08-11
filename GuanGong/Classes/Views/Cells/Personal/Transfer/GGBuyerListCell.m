//
//  GGBuyerListCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/18.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBuyerListCell.h"

NSString * const kCellIdentifierBuyerList = @"kGGBuyerListCell";

@interface GGBuyerListCell ()

@property(nonatomic,strong)UIImageView *rewardView;
@property(nonatomic,strong)UIButton *button;

@end

@implementation GGBuyerListCell


- (void)setupView{
    [super setupView];

    [self.contentView addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-12);
        make.size.mas_equalTo(CGSizeMake(64, 25));
        make.centerY.equalTo(self.contentView);
    }];
    
    
    
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
        if ([self.delegate respondsToSelector:@selector(buyerCellAction:)]) {
            [self.delegate buyerCellAction:x];
        }
    }];
    

}

- (void)configCellItem:(GGOrderList *)orderList
{
    [super configCellItem:orderList];
        
    if (orderList.hasReward) {
        self.accessoryView = self.rewardView;
        self.button.hidden = YES;
    }else{
        self.accessoryView = nil;
        
        NSString *title = nil;
        
        if (!orderList.hasPayAnother) {
            switch (orderList.statusId) {
                case OrderStatusTypeFDJ:
                    title = @"支付尾款";
                    break;
                    
                case OrderStatusTypeFWK:
                    title = @"确认收货";
                    break;
                    
                case OrderStatusTypeJYCG:
                    title = @"打赏";
                    break;
                    
                case OrderStatusTypeSQTK:
                    title = orderList.payOver ? @"确认收货":@"支付尾款";
                    break;
                    
                case OrderStatusTypeTKCG:
                    title = @"打赏";
                    break;
                    
                case OrderStatusTypeQKZF:
                    title = @"确认收货";
                    break;
                    
                case OrderStatusTypeJJTK:
                    title = orderList.payOver ? @"确认收货":@"支付尾款";
                    break;
                    
                case OrderStatusTypeZDJJTK:
                    title = @"支付尾款";
                    break;
                    
                case OrderStatusTypeZDQRSH:
                    title = @"打赏";
                    break;
                    
                case OrderStatusTypeKFJR:
                    title = @"确认收货";
                    break;
                    
                case OrderStatusTypeTHTK:
                    title = orderList.payOver ? @"确认收货":@"支付尾款";
                    break;
                    
                case OrderStatusTypeTYTHTK:
                    title = orderList.payOver ? @"确认收货":@"支付尾款";
                    break;
                    
                case OrderStatusTypeJJTHTK:
                    title = orderList.payOver ? @"确认收货":@"支付尾款";
                    break;
                    
                case OrderStatusTypeMJSHTK:
                    title = @"打赏";
                    break;
                    
                default:
                    
                    break;
            }
        }

        if (title) {
            self.button.hidden = NO;
            [self.button setTitle:title forState:UIControlStateNormal];
        }else{
            self.button.hidden = YES;
        }
    }
}


- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = [UIFont systemFontOfSize:12];
        _button.layer.borderColor = themeColor.CGColor;
        _button.layer.borderWidth = .5;
        _button.layer.cornerRadius = 4;
        _button.layer.masksToBounds = YES;
        [_button setTitleColor:themeColor forState:UIControlStateNormal];
        [_button setTitleColor:textLightColor forState:UIControlStateHighlighted];
    }
    return _button;
}

- (UIImageView *)rewardView{
    if (!_rewardView) {
        _rewardView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"payment_dasang"]];
        _rewardView.frame = CGRectMake(0, 0, 54, 43);
    }
    return _rewardView;
}


//createTime = 1469000591000;
//dealerIcon = "http://img3.csiautos.cn/guangong/2016/0725/20160725163455263.jpg";
//dealerId = 56;
//dealerMobile = 18101356409;
//dealerName = 23456;
//dealerRealName = "\U674e\U6d4b\U8bd5";
//description = "\U5168\U6b3e";
//goodsTypeId = 2;
//hasApplyReturn = 1;
//hasPayAnother = 0;
//hasReward = 0;
//id = 518;
//isBuyer = 1;
//isdel = 0;
//nextStepStatusName = "\U5356\U5bb6\U5904\U7406\U4e2d";
//orderNo = 1607200240796068;
//payAnotherId = "<null>";
//payOver = 1;
//price = 10;
//returnPrice = 10;
//statusId = 9;
//statusType = 2;
//updateTime = 1469000591000;



@end
