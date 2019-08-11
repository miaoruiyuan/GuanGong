//
//  GGTwoButtonsView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTwoButtonsView.h"
#import "FDStackView.h"

@interface GGTwoButtonsView ()

@property(nonatomic,strong,readwrite)UIButton *leftButtton;
@property(nonatomic,strong,readwrite)UIButton *rightButtton;
@property(nonatomic,strong)FDStackView *stackView;


@end

@implementation GGTwoButtonsView

#pragma mark - 买家
- (instancetype)initWithBuyerDetailObj:(GGOrderDetails *)detail isRefundDetail:(BOOL)refundDetail{
    if (self = [super init]) {
        [self addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 10, 5, 10));
        }];
        
        
        NSArray *titles = @[];
    
        if (!detail.hasPayAnother) {
            switch (detail.statusId) {
                case OrderStatusTypeFDJ:
                    titles = @[@"申请退款",@"支付尾款"];
                    break;
                    
                case OrderStatusTypeFWK:
                    if (!refundDetail) {
                        titles = @[@"申请退款",@"确认收货"];
                    }
                    break;
                    
                case OrderStatusTypeSQTK:
                    if (refundDetail) {
//                        titles = @[@"修改申请"];
                    }else{
                        //如果没有支付过尾款
                        titles = detail.payOver == 0 ? @[@"支付尾款"] :@[@"确认收货"];
                    }
                    break;
                    
                case OrderStatusTypeQKZF:
                    titles = @[@"申请退款",@"确认收货"];
                    break;
                    
                case OrderStatusTypeJJTK:
                    if (refundDetail) {
                        titles = @[@"修改申请"];
                    }else{
                        //如果没有支付过尾款
                        titles = detail.payOver == 0 ? @[@"支付尾款"] :@[@"确认收货"];
                    }
                    break;
                    
                case OrderStatusTypeZDJJTK:
                    titles = @[@"支付尾款"];
                    break;
                    
                case OrderStatusTypeKFJR:
                    titles = @[@"确认收货"];
                    break;
                    
                case OrderStatusTypeTHTK:
                    if (refundDetail) {
//                        titles = @[@"修改申请"];
                    }else{
                        //如果没有支付过尾款
                        titles = detail.payOver == 0 ? @[@"支付尾款"] :@[@"确认收货"];
                    }
                    break;
                    
                case OrderStatusTypeTYTHTK:
                    if (!refundDetail) {
                        titles = detail.payOver == 0 ? @[@"支付尾款"] :@[@"确认收货"];
                    }                    
                    break;
                    
                case OrderStatusTypeJJTHTK:
                    if (refundDetail) {
                        titles = @[@"修改申请"];
                    }else{
                        titles = detail.payOver == 0 ? @[@"支付尾款"] :@[@"确认收货"];
                    }
                    break;
                    
                default:
                    break;
            }

        }

    
        if (titles.count == 2) {
            [self.stackView addArrangedSubview:self.leftButtton];
            [self.stackView addArrangedSubview:self.rightButtton];
            [self.leftButtton setTitle:titles[0] forState:UIControlStateNormal];
            [self.rightButtton setTitle:titles[1] forState:UIControlStateNormal];
        }else if (titles.count == 1){
            [self.stackView removeAllSubviews];
            [self.stackView addArrangedSubview:self.leftButtton];
            [self.leftButtton setTitle:titles[0] forState:UIControlStateNormal];
        }else{
            [self.stackView removeAllSubviews];
        }
        
    }
    return self;
    
}

#pragma mark - 卖家
- (instancetype)initWithSellerDetailObj:(GGOrderDetails *)detail isRefundDetail:(BOOL)refundDetail{
    
    if (self = [super init]) {
        [self addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 10, 5, 10));
        }];
        
        NSArray *titles = @[];
        
        switch (detail.statusId) {
            case OrderStatusTypeFDJ:
                titles = detail.goodsInfo.title ? @[@"修改交易信息"]: @[@"上传交易信息"];
                break;
                
            case OrderStatusTypeFWK:
                if (!refundDetail) {
                    titles = detail.goodsInfo.title ? @[@"修改交易信息"]: @[@"上传交易信息"];
                }
                break;
                
            case OrderStatusTypeSQTK:
                if (refundDetail) {
                    if (!detail.hasPayAnother) {
                        titles = @[@"拒绝退款",@"同意退款"];
                    }
                }else{
                    titles = detail.goodsInfo.title ? @[@"修改交易信息"]: @[@"上传交易信息"];
                }
                break;
                
            case OrderStatusTypeQKZF:
                
                if (!refundDetail) {
                    titles = detail.goodsInfo.title ? @[@"修改交易信息"] : @[@"上传交易信息"];
                }
                break;
                
                
            case OrderStatusTypeJJTK:
                if (!refundDetail) {
                    titles = detail.goodsInfo.title ? @[@"修改交易信息"] : @[@"上传交易信息"];
                }
                break;
                
            case OrderStatusTypeTYTK:
                if (!refundDetail) {
                    titles = detail.goodsInfo.title ? @[@"修改交易信息"]: @[@"上传交易信息"];
                }
                break;

        
            case OrderStatusTypeTHTK:
                if (refundDetail) {
                    if (!detail.hasPayAnother) {
                        titles = @[@"拒绝退款",@"同意退款"];
                    }
                }else{
                    titles = detail.goodsInfo.title ? @[@"修改交易信息"]: @[@"上传交易信息"];
                }
                break;
                
                
            case OrderStatusTypeTYTHTK:
                if (refundDetail) {
                    if (!detail.hasPayAnother) {
                        titles = @[@"收到退货"];
                    }
                }else{
                    titles = detail.goodsInfo.title ? @[@"修改交易信息"]: @[@"上传交易信息"];
                }
                
                break;
                
            case OrderStatusTypeJJTHTK:
                if (!refundDetail) {
                    titles = detail.goodsInfo.title ? @[@"修改交易信息"] : @[@"上传交易信息"];
                }
            
            default:
                break;
        }
        
        
        if (titles.count == 2) {
            [self.stackView addArrangedSubview:self.leftButtton];
            [self.stackView addArrangedSubview:self.rightButtton];
            [self.leftButtton setTitle:titles[0] forState:UIControlStateNormal];
            [self.rightButtton setTitle:titles[1] forState:UIControlStateNormal];
        }else if (titles.count == 1){
            [self.stackView removeAllSubviews];
            [self.stackView addArrangedSubview:self.rightButtton];
            [self.rightButtton setTitle:titles[0] forState:UIControlStateNormal];
        }else{
            [self.stackView removeAllSubviews];
        }
    }
    
    return self;
}



- (void)leftOrRightButtonAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(twoButtonClicked:)]) {
        [self.delegate twoButtonClicked:sender];
    }
}

- (FDStackView *)stackView{
    if (!_stackView) {
        _stackView = [[FDStackView alloc] init];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.spacing = 10;
        
    }
    return _stackView;
}



- (UIButton *)leftButtton{
    if (!_leftButtton) {
        _leftButtton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButtton.titleLabel setFont:[UIFont systemFontOfSize:14.8]];
        [_leftButtton setTitleColor:textNormalColor forState:UIControlStateNormal];
        [_leftButtton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _leftButtton.layer.masksToBounds = YES;
        _leftButtton.layer.borderWidth = 1.0;
        _leftButtton.layer.borderColor = textLightColor.CGColor;
        _leftButtton.layer.cornerRadius = 4.0;
        [_leftButtton addTarget:self action:@selector(leftOrRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButtton;
}


- (UIButton *)rightButtton{
    if (!_rightButtton) {
        _rightButtton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButtton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        [_rightButtton.titleLabel setFont:[UIFont systemFontOfSize:14.8]];
        _rightButtton.layer.masksToBounds = YES;
        _rightButtton.layer.cornerRadius = 4.0;
        [_rightButtton addTarget:self action:@selector(leftOrRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButtton;
}


//- (instancetype)initWithButtonViewAndObject:(GGOrderList *)order isRefundDetail:(BOOL)refundDetail{
//
//    if (self = [super init]) {
//        self.backgroundColor = [UIColor whiteColor];
//
//        NSArray *titles = @[];
//
//        if (!order.isBuyer) {
//
//            switch (order.statusId) {
//                case OrderStatusTypeFDJ:
//                    _countType = ButtonCountTypeOne;
//                    titles = @[@"交易信息"];
//                    break;
//
//                case OrderStatusTypeFWK:
//                    _countType = ButtonCountTypeOne;
//                    titles = @[@"交易信息"];
//                    break;
//
//                case OrderStatusTypeSQTK:
//                    if (refundDetail) {
//                        _countType = ButtonCountTypeTwo;
//                       titles = @[@"拒绝退款",@"同意退款"];
//                    }else{
//                        _countType = ButtonCountTypeNone;
//                    }
//                    break;
//
//                case OrderStatusTypeQKZF:
//                    _countType = ButtonCountTypeOne;
//                    titles = @[@"交易信息"];
//                    break;
//
//                case OrderStatusTypeTHTK:
//                    if (refundDetail) {
//                        _countType = ButtonCountTypeTwo;
//                        titles = @[@"拒绝退款",@"同意退款"];
//                    }else{
//                        _countType = ButtonCountTypeNone;
//                    }
//                    break;
//
//
//                case OrderStatusTypeTYTHTK:
//                    if (refundDetail) {
//                        _countType = ButtonCountTypeOne;
//                        titles = @[@"确认收货"];
//                    }else{
//                        _countType = ButtonCountTypeNone;
//                    }
//                    break;
//
//                default:
//                    _countType = ButtonCountTypeNone;
//                    break;
//            }
//
//
//
//        }else{
//
//            switch (order.statusId) {
//                case OrderStatusTypeFDJ:
//                    _countType = ButtonCountTypeTwo;
//                    titles = @[@"申请退款",@"支付尾款"];
//                    break;
//
//                case OrderStatusTypeFWK:
//                    _countType = ButtonCountTypeTwo;
//                    titles = @[@"申请退款",@"确认收货"];
//                    break;
//
//                case OrderStatusTypeSQTK:
//                    _countType = ButtonCountTypeOne;
//                    titles = @[@"修改申请"];
//                    break;
//
//                case OrderStatusTypeQKZF:
//                    _countType = ButtonCountTypeTwo;
//                    titles = @[@"申请退款",@"确认收货"];
//                    break;
//
//                case OrderStatusTypeJJTK:
//                    _countType = ButtonCountTypeOne;
//                    titles = @[@"修改申请"];
//                    break;
//
//                case OrderStatusTypeZDJJTK:
//                    _countType = ButtonCountTypeOne;
//                    titles = @[@"支付尾款"];
//                    break;
//
//                case OrderStatusTypeKFJR:
//                    _countType = ButtonCountTypeOne;
//                    titles = @[@"确认收货"];
//                    break;
//
//                case OrderStatusTypeTHTK:
//                    _countType = ButtonCountTypeOne;
//                    titles = @[@"修改申请"];
//                    break;
//
//                case OrderStatusTypeJJTHTK:
//                    _countType = ButtonCountTypeOne;
//                    titles = @[@"修改申请"];
//                    break;
//
//                default:
//                    _countType = ButtonCountTypeNone;
//                    break;
//            }
//
//        }
//
//
//        switch (_countType) {
//            case ButtonCountTypeNone:{
//
//                [self addSubview:self.leftButtton];
//                [self.leftButtton mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.edges.equalTo(self);
//                    make.height.mas_equalTo(.01);
//                }];
//            }
//                break;
//
//            case ButtonCountTypeOne:{
//
//
//                [self addSubview:self.leftButtton];
//                [self.leftButtton mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(self.mas_left).with.offset(12);
//                    make.top.equalTo(self.mas_top).with.offset(6);
//                    make.bottom.equalTo(self.mas_bottom).offset(-6).priority(720);
//                    make.height.mas_equalTo(34);
//                }];
//
//                [self addSubview:self.rightButtton];
//                [self.rightButtton mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.right.equalTo(self.mas_right).with.offset(-12);
//                    make.centerY.equalTo(self.leftButtton);
//                    make.height.equalTo(self.leftButtton);
//                    make.left.equalTo(self.leftButtton.mas_right).offset(24);
//
//                    make.width.equalTo(self.leftButtton);
//                }];
//
//                self.leftButtton.hidden = YES;
//                [self.rightButtton setTitle:titles[0] forState:UIControlStateNormal];
//
//
//            }
//                break;
//
//            case ButtonCountTypeTwo:{
//
//                [self addSubview:self.leftButtton];
//                [self.leftButtton mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(self.mas_left).with.offset(12);
//                    make.top.equalTo(self.mas_top).with.offset(6);
//                    make.bottom.equalTo(self.mas_bottom).offset(-6).priority(720);
//                    make.height.mas_equalTo(34);
//                }];
//
//                [self addSubview:self.rightButtton];
//                [self.rightButtton mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.right.equalTo(self.mas_right).with.offset(-12);
//                    make.centerY.equalTo(self.leftButtton);
//                    make.height.equalTo(self.leftButtton);
//                    make.left.equalTo(self.leftButtton.mas_right).offset(24);
//
//                    make.width.equalTo(self.leftButtton);
//                }];
//
//
//                [self.leftButtton setTitle:titles[0] forState:UIControlStateNormal];
//                [self.rightButtton setTitle:titles[1] forState:UIControlStateNormal];
//
//            }
//
//                break;
//
//            default:
//                break;
//        }
//
//
//    }
//    return self;
//}
//

@end
