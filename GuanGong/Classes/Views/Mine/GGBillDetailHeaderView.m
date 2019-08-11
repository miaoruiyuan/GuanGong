//
//  GGBillDetailHeaderView.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/24.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBillDetailHeaderView.h"
#import "FDStackView.h"

@interface GGBillDetailHeaderView ()

@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *stateLabel;

@property(nonatomic,strong)UIView *cardView;
@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UIButton *nameButton;

@property(nonatomic,strong)UIView *line1;

@property(nonatomic,strong)FDStackView *orderLeftStackView;
@property(nonatomic,strong)FDStackView *orderRightStackView;

@property(nonatomic,strong)UIView *line2;

@property(nonatomic,strong)FDStackView *timeLeftStackView;
@property(nonatomic,strong)FDStackView *timeRightStackView;

@end

@implementation GGBillDetailHeaderView

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image]) {
       
        [self addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(28);
            make.height.mas_equalTo(32);
            make.centerX.equalTo(self);
        }];
        
    
        [self addSubview:self.stateLabel];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.priceLabel);
            make.height.mas_equalTo(16);
        }];
        
        
        [self addSubview:self.cardView];
        [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.top.equalTo(self.stateLabel.mas_bottom).offset(23);
        }];
        
        [self.cardView addSubview:self.nameButton];
        [self.nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cardView.mas_top).offset(25);
            make.centerX.equalTo(self.cardView.mas_centerX).offset(17);
            make.height.mas_equalTo(19);
        }];
        
        [self.cardView addSubview:self.headView];
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cardView.mas_top).offset(22);
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.right.equalTo(self.nameButton.mas_left).offset(-7);
        }];
        
        [self.cardView addSubview:self.line1];
        [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headView.mas_bottom).offset(16);
            make.left.equalTo(self.cardView.mas_left).offset(20);
            make.right.equalTo(self.cardView.mas_right).offset(-20);
            make.height.mas_equalTo(1);
        }];
        
        [self.cardView addSubview:self.orderLeftStackView];
        [self.orderLeftStackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.line1);
            make.top.equalTo(self.line1.mas_bottom).offset(16);
            make.width.mas_equalTo(80);
        }];
        
        [self.cardView addSubview:self.orderRightStackView];
        [self.orderRightStackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.line1);
            make.top.equalTo(self.line1.mas_bottom).offset(16);
            make.left.equalTo(self.orderLeftStackView.mas_right);
        }];
        
        
        [self.cardView addSubview:self.line2];
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.orderRightStackView.mas_bottom).offset(12);
            make.left.right.height.equalTo(self.line1);
           // make.bottom.equalTo(self.cardView.mas_bottom).offset(-16);
        }];
        
        [self.cardView addSubview:self.timeLeftStackView];
        [self.timeLeftStackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line2.mas_bottom).offset(12);
            make.left.equalTo(self.line2);
            make.bottom.equalTo(self.cardView.mas_bottom).offset(-16);
        }];
        [self.cardView addSubview:self.timeRightStackView];
        [self.timeRightStackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line2.mas_bottom).offset(12);
            make.right.equalTo(self.line2);
            make.bottom.equalTo(self.cardView.mas_bottom).offset(-16);
        }];
    
    }
    return self;
}

- (void)setInfo:(GGBillInfo *)info
{
    if (_info != info) {
        _info = info;

        self.priceLabel.text = [NSString stringWithFormat:@"%@ %@",_info.tranFlag == 1 ? @"-" : @"+",_info.tranAmountStr];
        
        self.stateLabel.text = _info.dealTypeName;
        
        [self.headView setImageWithURL:[NSURL URLWithString:_info.dealerIcon] placeholder:[UIImage imageNamed:@"user_header_default"]];
        
        [self.nameButton setTitle:_info.dealerRealName forState:UIControlStateNormal];
        self.btnTapSinal = [self.nameButton rac_signalForControlEvents:UIControlEventTouchUpInside];

        //用户按钮是否可以点击进入详情页
        if (_info.dealerIsUser == 1) {
            [self.nameButton setImage:[UIImage imageNamed:@"arrow_right_normal"] forState:UIControlStateNormal];
            self.nameButton.enabled = YES;
        }else{
            self.nameButton.enabled = NO;
        }
        
        [self createGoodInfoView];
        [self createTimeView];
    }
}

- (void)createGoodInfoView
{
    //goodsType 1-车 2-虚拟商品 3-提现 4-质检 5-物流 6-打赏 7-代付 9-充值
    
    NSMutableArray *titleArray = [@[@"交易类型"] mutableCopy];
    NSMutableArray *valueArray = [@[_info.operName] mutableCopy];
    
    if (_info.goodsType == 3){
        [titleArray addObject:@"提现到"];
        [valueArray addObject:_info.dealerRealName];
        [titleArray addObject:@"手续费"];
        NSString *handFeeStr = [NSString stringWithFormat:@"%@元",_info.handFeeStr];
        [valueArray addObject:handFeeStr];
    } else if (_info.goodsType == 7) {
        [titleArray addObject:@"申请人"];
        [valueArray addObject:_info.goodsRemark1];
    } else if (_info.goodsType == 9){
        [titleArray addObject:@"付款方式"];
        [valueArray addObject:_info.dealerRealName];
    } else {
        [titleArray addObject:@"商品信息"];
        [valueArray addObject:_info.goodsName];
    }
    
    [titleArray addObject:@"备注"];
    [valueArray addObject:(_info.remark && _info.remark.length > 0) ? _info.remark : @"无"];
    
    for (int i = 0; i < valueArray.count ; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%@",titleArray[i]];
        label.textColor = [UIColor colorWithHexString:@"000000"];
        label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        label.numberOfLines = 0;
        [self.orderLeftStackView addArrangedSubview:label];
        
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.text = [NSString stringWithFormat:@"%@",valueArray[i]];
        desLabel.textColor = [UIColor colorWithHexString:@"000000"];
        desLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        desLabel.textAlignment = NSTextAlignmentRight;
        desLabel.numberOfLines = 0;
        [self.orderRightStackView addArrangedSubview:desLabel	];
    }
}

- (void)createTimeView
{
    NSArray *timeTitleArray = @[@"创建时间",@"订单编号",@"交易号"];
    NSArray *timeValueArray = @[_info.tranDateStr,_info.orderNo,_info.payId];
    
    for (int i = 0; i < timeValueArray.count; i ++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = timeTitleArray[i];
        titleLabel.textColor = [UIColor colorWithHexString:@"737373"];
        titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = timeValueArray[i];
        contentLabel.textColor = [UIColor colorWithHexString:@"737373"];
        contentLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
        contentLabel.textAlignment = NSTextAlignmentRight;
    
        [self.timeLeftStackView addArrangedSubview:titleLabel];
        [self.timeRightStackView addArrangedSubview:contentLabel];
    }

}

#pragma mark - init View

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = [UIColor colorWithHexString:@"353535"];
        _priceLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightSemibold];
    }
    return _priceLabel;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _stateLabel.textColor = [UIColor colorWithHexString:@"737373"];
    }
    return _stateLabel;
}

- (UIView *)cardView{
    if (!_cardView) {
        _cardView = [[UIView alloc] init];
        _cardView.backgroundColor = [UIColor whiteColor];
        _cardView.layer.masksToBounds = YES;
        _cardView.layer.cornerRadius = 6;
    }
    return _cardView;
}

- (UIImageView *)headView{
    if (!_headView) {
        _headView = [[UIImageView alloc] init];
    }
    return _headView;
}

- (UIButton *)nameButton
{
    if (!_nameButton) {
        _nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nameButton.titleLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightThin]];
        [_nameButton setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
        [_nameButton putImageOnTheRightSideOfTitle];
    }
    return _nameButton;
}

- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = sectionColor;
    }
    return _line1;
}

- (UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = sectionColor;
    }
    return _line2;
}

- (FDStackView *)orderLeftStackView{
    if (!_orderLeftStackView) {
        _orderLeftStackView = [[FDStackView alloc] initWithArrangedSubviews:@[]];
        _orderLeftStackView.translatesAutoresizingMaskIntoConstraints = NO;
        _orderLeftStackView.axis = UILayoutConstraintAxisVertical;
        _orderLeftStackView.distribution = UIStackViewDistributionFillEqually;
        _orderLeftStackView.alignment = UIStackViewAlignmentFill;
        _orderLeftStackView.spacing = 10;
    }
    return _orderLeftStackView;
}

- (FDStackView *)orderRightStackView{
    if (!_orderRightStackView) {
        _orderRightStackView = [[FDStackView alloc] initWithArrangedSubviews:@[]];
        _orderRightStackView.translatesAutoresizingMaskIntoConstraints = NO;
        _orderRightStackView.axis = UILayoutConstraintAxisVertical;
        _orderRightStackView.distribution = UIStackViewDistributionFillEqually;
        _orderRightStackView.alignment = UIStackViewAlignmentTrailing;
        _orderRightStackView.spacing = 10;
    }
    return _orderRightStackView;
}

- (FDStackView *)timeLeftStackView{
    if (!_timeLeftStackView) {
        _timeLeftStackView = [[FDStackView alloc] initWithArrangedSubviews:@[]];
        _timeLeftStackView.translatesAutoresizingMaskIntoConstraints = NO;
        _timeLeftStackView.axis = UILayoutConstraintAxisVertical;
        _timeLeftStackView.distribution = UIStackViewDistributionFillEqually;
        _timeLeftStackView.alignment = UIStackViewAlignmentFill;
        _timeLeftStackView.spacing = 10;
    }
    return _timeLeftStackView;
}

- (FDStackView *)timeRightStackView{
    if (!_timeRightStackView) {
        _timeRightStackView = [[FDStackView alloc] initWithArrangedSubviews:@[]];
        _timeRightStackView.translatesAutoresizingMaskIntoConstraints = NO;
        _timeRightStackView.axis = UILayoutConstraintAxisVertical;
        _timeRightStackView.distribution = UIStackViewDistributionFillEqually;
        _timeRightStackView.alignment = UIStackViewAlignmentTrailing;
        _timeRightStackView.spacing = 10;
    }
    return _timeRightStackView;
}

@end
