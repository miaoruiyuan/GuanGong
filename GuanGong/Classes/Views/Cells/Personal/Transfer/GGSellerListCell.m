//
//  GGSellerListCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/18.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGSellerListCell.h"

@interface GGSellerListCell ()

@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UIImageView *rewardView;

@end

NSString * const kCellIdentifierSellerList = @"kGGSellerListCell";

@implementation GGSellerListCell

- (void)setupView{
    [super setupView];
    
    
    [self.contentView addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-12);
        make.size.mas_equalTo(CGSizeMake(64, 25));
        make.centerY.equalTo(self.contentView);

    }];
    

    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
        
        if ([self.delegate respondsToSelector:@selector(sellerCellAction:)]) {
            [self.delegate sellerCellAction:x];
        }
    }];
    
}



- (void)configCellItem:(GGOrderList *)orderList{
    [super configCellItem:orderList];
    
    
    if (orderList.hasReward) {
        self.accessoryView = self.rewardView;
        self.button.hidden = YES;
    }else{
        self.accessoryView = nil;
        
        switch (orderList.statusId) {
            case OrderStatusTypeJYCG:
                self.button.hidden = NO;
                
                break;
                
            case OrderStatusTypeTKCG:
                self.button.hidden = NO;
                break;
                
            case OrderStatusTypeZDQRSH:
                self.button.hidden = NO;
                break;
                
            case OrderStatusTypeMJSHTK:
                self.button.hidden = NO;
                break;
                
            default:
                self.button.hidden = YES;
                break;
                
        }
        
        
        if (self.button.hidden == NO) {
            [self.button setTitle:@"打赏" forState:UIControlStateNormal];
        }

    }
}


- (UIButton *)button
{
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


@end
