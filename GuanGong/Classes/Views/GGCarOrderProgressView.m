//
//  GGCarOrderProgressView.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/30.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarOrderProgressView.h"

@interface GGCarOrderProgressView ()

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIView *view1;
@property(nonatomic,strong)UIView *view2;
@property(nonatomic,strong)UIView *view3;
@property(nonatomic,strong)UIView *view4;

@property(nonatomic,strong)UILabel *tipLabel;

@property(nonatomic,strong)UIView *line1;
@property(nonatomic,strong)UIView *line2;
@property(nonatomic,strong)UIView *line3;

@property(nonatomic,strong)UIImageView *waitImageView;
@property(nonatomic,strong)UIImageView *doneImageView;
//退款的时候显示
@property(nonatomic,strong)UILabel *payBackLabel;

@property(nonatomic,strong)MASConstraint *labelCenterXConstraint;

@end

#define progressLineColor [UIColor colorWithHexString:@"ff8282"]

#define trackLineColor [UIColor colorWithHexString:@"dddddd"]

@implementation GGCarOrderProgressView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(22);
            make.height.mas_equalTo(16);
        }];
        
        [self addSubview:self.line2];
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            if (kScreenWidth == 320) {
                make.size.mas_equalTo(CGSizeMake(70, 3));
            }else{
                make.size.mas_equalTo(CGSizeMake(80, 3));
            }
        }];
        
        [self addSubview:self.view2];
        [self.view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.line2.mas_left);
            make.centerY.equalTo(self.line2.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        
        [self addSubview:self.view3];
        [self.view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.line2.mas_right);
            make.centerY.equalTo(self.line2.mas_centerY);
            make.size.equalTo(self.view2);
        }];
        
        [self addSubview:self.line1];
        [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view2.mas_left);
            make.centerY.equalTo(self.view2.mas_centerY);
            make.size.equalTo(self.line2);
        }];
        
        [self addSubview:self.view1];
        [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.line1.mas_left);
            make.centerY.equalTo(self.line1.mas_centerY);
            make.size.equalTo(self.view2);
        }];
        
        
        [self addSubview:self.line3];
        [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view3.mas_right);
            make.centerY.equalTo(self.view3);
            make.size.equalTo(self.line2);
        }];
        
        [self addSubview:self.view4];
        [self.view4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.line3.mas_right);
            make.centerY.equalTo(self.line3.mas_centerY);
            make.size.equalTo(self.view3);
        }];
        
    
        [self addSubview:self.tipLabel];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            self.labelCenterXConstraint = make.centerX.equalTo(self.view1.mas_centerX);
//            make.left.mas_greaterThanOrEqualTo(0);
//            make.right.mas_lessThanOrEqualTo(kScreenWidth);
            make.top.equalTo(self.view1.mas_bottom).offset(12);
            make.height.mas_equalTo(13);
        }];
    }
    return self;
}


- (void)setOrderDetail:(GGCarOrderDetail *)orderDetail{
    _orderDetail = orderDetail;
    
    [self timeHandler];
    if (_waitImageView) {
        [_waitImageView removeFromSuperview];
    }
    if (_doneImageView) {
        [_doneImageView removeFromSuperview];
    }
    
    [self.payBackLabel removeFromSuperview];
    
    [self.labelCenterXConstraint uninstall];
    
    switch (_orderDetail.status) {
        case CarOrderStatusCJDD:{
            [self addSubview:self.waitImageView];
            [self.waitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(25, 25));
                make.center.equalTo(self.view1);
            }];
            [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                self.labelCenterXConstraint = make.centerX.equalTo(self.view1.mas_centerX);
            }];
            
            self.tipLabel.text = @"待支付订金";
            self.view1.backgroundColor = [UIColor whiteColor];
            self.line1.backgroundColor = trackLineColor;
            self.view2.backgroundColor = trackLineColor;
            self.line2.backgroundColor = trackLineColor;
            self.view3.backgroundColor = trackLineColor;
            self.line3.backgroundColor = trackLineColor;
            self.view4.backgroundColor = trackLineColor;
        }
            break;
            
        case CarOrderStatusZFDJ:{
            [self addSubview:self.waitImageView];
            [self.waitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(25, 25));
                make.center.equalTo(self.view2);
            }];
            
            [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                self.labelCenterXConstraint = make.centerX.equalTo(self.view2.mas_centerX);
            }];
            
            self.tipLabel.text = @"待支付尾款";
            self.view2.backgroundColor = [UIColor whiteColor];
            self.view1.backgroundColor = progressLineColor;
            self.line1.backgroundColor = progressLineColor;
            self.line2.backgroundColor = trackLineColor;
            self.view3.backgroundColor = trackLineColor;
            self.line3.backgroundColor = trackLineColor;
            self.view4.backgroundColor = trackLineColor;
            
        }
            break;

            
        case CarOrderStatusZFWK:
        case CarOrderStatusYFH:
        {
            [self addSubview:self.waitImageView];
            [self.waitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(25, 25));
                make.center.equalTo(self.view3);
            }];
            
            [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                self.labelCenterXConstraint = make.centerX.equalTo(self.view3.mas_centerX);
            }];

            self.tipLabel.text = @"待确认收货";
            self.view3.backgroundColor = [UIColor whiteColor];
            self.view1.backgroundColor = progressLineColor;
            self.line1.backgroundColor = progressLineColor;
            self.view2.backgroundColor = progressLineColor;
            self.line2.backgroundColor = progressLineColor;
            self.line3.backgroundColor = trackLineColor;
            self.view4.backgroundColor = trackLineColor;
        }
            break;

        case CarOrderStatusJYWC:{
            [self addSubview:self.doneImageView];
            [self.doneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(25, 25));
                make.center.equalTo(self.view4);
            }];
            
            [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                self.labelCenterXConstraint = make.centerX.equalTo(self.view4.mas_centerX);
            }];
            
            self.tipLabel.text = @"交易完成";
            
            self.view4.backgroundColor = [UIColor whiteColor];
            self.view1.backgroundColor = progressLineColor;
            self.line1.backgroundColor = progressLineColor;
            self.view2.backgroundColor = progressLineColor;
            self.line2.backgroundColor = progressLineColor;
            self.view3.backgroundColor = progressLineColor;
            self.line3.backgroundColor = progressLineColor;
        }
            break;
            
        case CarOrderStatusSQTK:{
            [self removeAllSubviews];
            [self addSubview:self.payBackLabel];
            [self.payBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.height.mas_equalTo(18);
            }];
            
            self.payBackLabel.text  = @"申请退款中";
            
        }
            break;
            
        case CarOrderStatusSQTH:{
            [self removeAllSubviews];
            [self addSubview:self.payBackLabel];
            [self.payBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.height.mas_equalTo(18);
            }];
            
            self.payBackLabel.text  = @"申请退货中";
            
        }
            break;

        case CarOrderStatusJJTK:{
            [self removeAllSubviews];
            [self addSubview:self.payBackLabel];
            [self.payBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.height.mas_equalTo(18);
            }];
            
            self.payBackLabel.text  = @"拒绝退款";
            
        }
            break;
            
        case CarOrderStatusJJTH:{
            [self removeAllSubviews];
            [self addSubview:self.payBackLabel];
            [self.payBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.height.mas_equalTo(18);
            }];
            
            self.payBackLabel.text  = @"拒绝退货";
            
        }
            break;
            
        case CarOrderStatusTYTK:{
            [self removeAllSubviews];
            [self addSubview:self.payBackLabel];
            [self.payBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.height.mas_equalTo(18);
            }];
            
            self.payBackLabel.text  = @"同意退款";
            
        }
            break;

            
        case CarOrderStatusTYTH:{
            [self removeAllSubviews];
            [self addSubview:self.payBackLabel];
            [self.payBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.height.mas_equalTo(18);
            }];
            
            self.payBackLabel.text  = @"同意退货";
            
        }
            break;

        case CarOrderStatusYTH:{
            [self removeAllSubviews];
            [self addSubview:self.payBackLabel];
            [self.payBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.height.mas_equalTo(18);
            }];
            
            self.payBackLabel.text  = @"已退货";
            
        }
            break;
            
        case CarOrderStatusDDGB:{
            [self removeAllSubviews];
            [self addSubview:self.payBackLabel];
            [self.payBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.height.mas_equalTo(18);
            }];
            
            self.payBackLabel.text  = @"订单关闭";
            
        }
        break;

        default:
            break;
    }
}

- (void)updateTimeDown:(NSString *)timeString
{
//    [self timeHandler];
//    self.timeLabel.text = timeString;
}

#pragma mark - 倒计时处理
- (void)timeHandler
{
    if (_orderDetail.status == CarOrderStatusZFWK || _orderDetail.status == CarOrderStatusZFDJ || _orderDetail.status == CarOrderStatusYFH) {
        self.timeLabel.hidden = NO;
    }else{
        self.timeLabel.hidden = YES;
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIImage *bgImage = [UIImage imageNamed:@"car_order_bg"];
    [bgImage drawInRect:rect];
}


#pragma mark - init View

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = textNormalColor;
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

- (UIView *)view1{
    if (!_view1) {
        _view1 = [[UIImageView alloc] init];
        _view1.layer.masksToBounds = YES;
        _view1.layer.cornerRadius = 6;
        _view1.backgroundColor = trackLineColor;
    }
    return _view1;
}

- (UIView *)view2{
    if (!_view2) {
        _view2 = [[UIImageView alloc] init];
        _view2.layer.masksToBounds = YES;
        _view2.layer.cornerRadius = 6;
        _view2.backgroundColor = trackLineColor;
    }
    return _view2;
}

- (UIView *)view3{
    if (!_view3) {
        _view3 = [[UIImageView alloc] init];
        _view3.layer.masksToBounds = YES;
        _view3.layer.cornerRadius = 6;
        _view3.backgroundColor = trackLineColor;
    }
    return _view3;
}

- (UIView *)view4{
    if (!_view4) {
        _view4 = [[UIImageView alloc] init];
        _view4.layer.masksToBounds = YES;
        _view4.layer.cornerRadius = 6;
        _view4.backgroundColor = trackLineColor;
    }
    return _view4;
}


- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = textLightColor;
        _tipLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
    }
    return _tipLabel;
}


- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = trackLineColor;
    }
    return _line1;
}


- (UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = trackLineColor;
    }
    return _line2;
}


- (UIView *)line3{
    if (!_line3) {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = trackLineColor;
    }
    return _line3;
}


- (UIImageView *)waitImageView{
    if (!_waitImageView) {
        _waitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"car_order_progress_wait"]];
        _waitImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _waitImageView;
}


- (UIImageView *)doneImageView{
    if (!_doneImageView) {
        _doneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"car_order_progress_done"]];
        _doneImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _doneImageView;
}

- (UILabel *)payBackLabel{
    if (!_payBackLabel) {
        _payBackLabel = [[UILabel alloc] init];
        _payBackLabel.textColor = themeColor;
        _payBackLabel.textAlignment = NSTextAlignmentCenter;
        _payBackLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
    }
    return _payBackLabel;
}

@end
