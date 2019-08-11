//
//  GGCarOrderBottomView.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/12/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarOrderBottomView.h"

@interface GGCarOrderBottomView ()

@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UIButton *rightButton;

@end

@implementation GGCarOrderBottomView

- (id)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setOrderDetail:(GGCarOrderDetail *)orderDetail{
    _orderDetail = orderDetail;
    
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.left.equalTo(self.leftButton.mas_right).offset(20);
        make.top.bottom.width.equalTo(self.leftButton);
    }];
    
    
    switch (_orderDetail.status) {
        case CarOrderStatusCJDD:{
            self.leftButton.hidden = YES;
            self.rightButton.hidden = NO;
            if ([_orderDetail.saleId isEqualToNumber:[GGLogin shareUser].user.userId]) {
                [self.rightButton setTitle:@"修改价格" forState:UIControlStateNormal];
            }else{
                
                if (_orderDetail.hasPayAnother) {
                    [self.rightButton setTitle:@"取消代付" forState:UIControlStateNormal];
                }else{
                    [self.rightButton setTitle:@"支付订金" forState:UIControlStateNormal];
                }
            }
            
        }
            break;
            
        case CarOrderStatusZFDJ:{
            
            if ([_orderDetail.saleId isEqualToNumber:[GGLogin shareUser].user.userId]) {
                [self removeAllSubviews];
            }else{
                if (_orderDetail.car.carType == 1) {
                    self.leftButton.hidden = YES;
                    self.rightButton.hidden = NO;
                }else{
                    self.leftButton.hidden = NO;
                    self.rightButton.hidden = NO;
                    [self.leftButton setTitle:@"申请退款" forState:UIControlStateNormal];
                    [self.rightButton setTitle:@"支付尾款" forState:UIControlStateNormal];
                }
                
                if (_orderDetail.hasPayAnother) {
                    [self.rightButton setTitle:@"取消代付" forState:UIControlStateNormal];
                }else{
                    [self.rightButton setTitle:@"支付尾款" forState:UIControlStateNormal];
                }
            }
        }
            break;
            
            
        case CarOrderStatusZFWK:{
            [self removeAllSubviews];
        }
            break;
            
            
        case CarOrderStatusYFH:{
            if (![_orderDetail.saleId isEqualToNumber:[GGLogin shareUser].user.userId]) {
                
                if (_orderDetail.car.carType == 1) {
                    self.leftButton.hidden = YES;
                    self.rightButton.hidden = NO;
                    [self.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
                }else{
                    self.leftButton.hidden = NO;
                    self.rightButton.hidden = NO;
                    [self.leftButton setTitle:@"申请退款" forState:UIControlStateNormal];
                    [self.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
                }
            }
        }
            break;
            
            
        case CarOrderStatusJYWC:{
            [self removeAllSubviews];
        }
            break;
            
        case CarOrderStatusFKGMJ:{
            [self removeAllSubviews];
        }
            break;
            
        case CarOrderStatusSQTK:{
        
            if (![_orderDetail.saleId isEqualToNumber:[GGLogin shareUser].user.userId]) {
            
                if (_orderDetail.payOver) {
                    self.leftButton.hidden = YES;
                    self.rightButton.hidden = NO;
                    [self.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
                }else{
                    [self.rightButton setTitle:@"支付尾款" forState:UIControlStateNormal];
                }
                
                if (_isRefund) {
                    self.leftButton.hidden = NO;
                    self.rightButton.hidden = YES;
                    [self.leftButton setTitle:@"修改申请" forState:UIControlStateNormal];
                }
            }else{
                if (_isRefund) {
                    self.leftButton.hidden = NO;
                    self.rightButton.hidden = NO;
                    [self.leftButton setTitle:@"拒绝退款" forState:UIControlStateNormal];
                    [self.rightButton setTitle:@"同意退款" forState:UIControlStateNormal];
                }
            }
        }
            break;
            
        case CarOrderStatusSQTH:{
            if (![_orderDetail.saleId isEqualToNumber:[GGLogin shareUser].user.userId]) {
                self.leftButton.hidden = YES;
                self.rightButton.hidden = NO;
                
                if (_orderDetail.payOver) {
                    [self.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
                }else{
                    [self.rightButton setTitle:@"支付尾款" forState:UIControlStateNormal];
                }
                
                if (_isRefund) {
                    self.leftButton.hidden = NO;
                    self.rightButton.hidden = YES;
                    [self.leftButton setTitle:@"修改申请" forState:UIControlStateNormal];
                }
            }else{
                if (_isRefund) {
                    self.leftButton.hidden = NO;
                    self.rightButton.hidden = NO;
                    [self.leftButton setTitle:@"拒绝退货" forState:UIControlStateNormal];
                    [self.rightButton setTitle:@"同意退货" forState:UIControlStateNormal];
                }
            }

        }
            break;
            
        case CarOrderStatusJJTK:{
            if (![_orderDetail.saleId isEqualToNumber:[GGLogin shareUser].user.userId]) {
                self.leftButton.hidden = YES;
                self.rightButton.hidden = NO;
                
                if (_orderDetail.payOver) {
                    [self.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
                }else{
                    [self.rightButton setTitle:@"支付尾款" forState:UIControlStateNormal];
                }
                
                if (_isRefund) {
                    self.leftButton.hidden = NO;
                    self.rightButton.hidden = YES;
                    [self.leftButton setTitle:@"修改申请" forState:UIControlStateNormal];
                }
            }

        }
            break;
            
        case CarOrderStatusJJTH:{
            if (![_orderDetail.saleId isEqualToNumber:[GGLogin shareUser].user.userId]) {
                self.leftButton.hidden = YES;
                self.rightButton.hidden = NO;
                
                if (_orderDetail.payOver) {
                    [self.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
                }else{
                    [self.rightButton setTitle:@"支付尾款" forState:UIControlStateNormal];
                }
                
                if (_isRefund) {
                    self.leftButton.hidden = NO;
                    self.rightButton.hidden = YES;
                    [self.leftButton setTitle:@"修改申请" forState:UIControlStateNormal];
                }
            }

        }
            break;
            
        case CarOrderStatusTYTK:{
            [self removeAllSubviews];
        }
            break;
            
        case CarOrderStatusTYTH:{
            if (![_orderDetail.saleId isEqualToNumber:[GGLogin shareUser].user.userId]) {
                self.leftButton.hidden = YES;
                self.rightButton.hidden = NO;
                
                if (_orderDetail.payOver) {
                    [self.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
                }else{
                    [self.rightButton setTitle:@"支付尾款" forState:UIControlStateNormal];
                }
            }else{
                if (_isRefund) {
                    self.leftButton.hidden = YES;
                    self.rightButton.hidden = NO;
                    [self.rightButton setTitle:@"收到退货" forState:UIControlStateNormal];
                }
            }

        }
            break;
            
        case CarOrderStatusTKGMJ:{
            [self removeAllSubviews];
        }
            break;
            
        case CarOrderStatusYTH:{
            [self removeAllSubviews];
        }
            break;
            
        default:
            break;
    }

    if (self.leftButton.hidden && self.rightButton.hidden) {
        self.isShow = NO;
    } else {
        self.isShow = YES;
    }
}

- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftButton.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightLight]];
        [_leftButton.layer setMasksToBounds:YES];
        [_leftButton.layer setCornerRadius:6];
        [_leftButton.layer setBorderWidth:.8];
        [_leftButton.layer setBorderColor:[UIColor blackColor].CGColor];
        [[_leftButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
            if ([self.delegate respondsToSelector:@selector(carOrderDetailButtonClicked:)]) {
                [self.delegate carOrderDetailButtonClicked:x];
            }
        }];
    }
    return _leftButton;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightLight]];
        [_rightButton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        [_rightButton.layer setMasksToBounds:YES];
        [_rightButton.layer setCornerRadius:6];
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
            if ([self.delegate respondsToSelector:@selector(carOrderDetailButtonClicked:)]) {
                [self.delegate carOrderDetailButtonClicked:x];
            }
        }];
    }
    return _rightButton;
}

@end
