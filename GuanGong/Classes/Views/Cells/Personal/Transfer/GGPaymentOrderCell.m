//
//  GGPaymentOrderCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPaymentOrderCell.h"
#import "TTTAttributedLabel.h"

@interface GGPaymentOrderCell ()

@property(nonatomic,strong)UIImageView *typeView;
@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)TTTAttributedLabel *statusLabel;
@property(nonatomic,strong)UILabel *fromLabel;




@end

@implementation GGPaymentOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
       
        [self setupView];
    }
    return self;
}

- (void)setupView{

    
    [self.contentView addSubview:self.typeView];
    [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(kLeftPadding);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];
    
    [self.typeView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.typeView);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeView.mas_right).offset(15);
        make.top.equalTo(self.contentView.mas_top).with.offset(20);
        make.height.mas_equalTo(16);
    }];
    
    [self.contentView addSubview:self.fromLabel];
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLabel);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-20);
    }];
    

}


- (void)configCellItem:(GGOrderList *)orderList{

    NSString *title = [NSString stringWithFormat:@"%@%@    %@",orderList.isBuyer ? @"卖家: ":@"买家: ",orderList.dealerRealName,[NSDate dateWithTimeIntreval:orderList.createTime]];
    
    self.fromLabel.text = title;

    self.statusLabel.text = orderList.nextStepStatusName;    
    if (orderList.hasPayAnother) {
        [self.statusLabel setText:[NSString stringWithFormat:@"%@(已申请代付)",orderList.nextStepStatusName] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange markRange = [[mutableAttributedString string] rangeOfString:@"(已申请代付)" options:NSCaseInsensitiveSearch];
            [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName: themeColor,NSFontAttributeName : [UIFont systemFontOfSize:12 weight:UIFontWeightLight]} range:markRange];
            
            return mutableAttributedString;
        }];
    }

    
//    UIColor *greenColor = [UIColor colorWithHexString:@"89b1ec"];
//    UIColor *redColor = [UIColor colorWithHexString:@"f68c8d"];
    
    switch (orderList.statusId) {
        case OrderStatusTypeFDJ:{
            self.typeView.image = [UIImage imageNamed:@"payment_dinjin"];
            self.typeLabel.text = @"订";
            self.typeLabel.textColor = [UIColor colorWithHexString:@"89b1ec"];
        }
            break;
            
        case OrderStatusTypeFWK:{
            self.typeView.image = [UIImage imageNamed:@"payment_quankuan"];
            self.typeLabel.text = @"尾";
            self.typeLabel.textColor = [UIColor colorWithHexString:@"89b1ec"];
            
        }
            break;
            
        case OrderStatusTypeJYCG:{
            if (orderList.statusType == OrderPaymentTypeWK) {
                self.typeView.image = [UIImage imageNamed:@"payment_weikuan"];
                self.typeLabel.text = @"尾";
                self.typeLabel.textColor = [UIColor colorWithHexString:@"81d49c"];
            }else if(orderList.statusType == OrderPaymentTypeQK){
                self.typeView.image = [UIImage imageNamed:@"payment_weikuan"];
//                self.typeLabel.text = @"全";
                self.typeLabel.text = @"保";
                self.typeLabel.textColor = [UIColor colorWithHexString:@"81d49c"];
            }
            
        }
            break;
            
        case OrderStatusTypeSQTK:{
            self.typeView.image = [UIImage imageNamed:@"payment_tuikuan"];
            self.typeLabel.text = @"退";
            self.typeLabel.textColor = [UIColor colorWithHexString:@"f68c8d"];
            
        }
            break;
            
        case OrderStatusTypeTKCG:{
            self.typeView.image = [UIImage imageNamed:@"payment_weikuan"];
            self.typeLabel.text = @"退";
            self.typeLabel.textColor = [UIColor colorWithHexString:@"81d49c"];
            
        }
            break;
            
        case OrderStatusTypeQKZF:{
            self.typeView.image = [UIImage imageNamed:@"payment_quankuan"];
//            self.typeLabel.text = @"全";
            self.typeLabel.text = @"保";

            self.typeLabel.textColor = [UIColor colorWithHexString:@"89b1ec"];
            
        }
            break;

        case OrderStatusTypeJJTK:{
            self.typeView.image = [UIImage imageNamed:@"payment_tuikuan"];
            self.typeLabel.text = @"退";
            self.typeLabel.textColor = [UIColor colorWithHexString:@"f68c8d"];
        }
            break;

        case OrderStatusTypeTYTK:{
            self.typeView.image = [UIImage imageNamed:@"payment_tuikuan"];
            self.typeLabel.text = @"退";
            self.typeLabel.textColor = [UIColor colorWithHexString:@"f68c8d"];
        }
            break;
            
        case OrderStatusTypeZDJJTK:{
            self.typeView.image = [UIImage imageNamed:@"payment_tuikuan"];
            self.typeLabel.text = @"退";
            self.typeLabel.textColor = [UIColor colorWithHexString:@"f68c8d"];
        }
            break;
            
        case OrderStatusTypeZDQRSH:{
            if (orderList.payOver) {
                self.typeView.image = [UIImage imageNamed:@"payment_quankuan"];
//                self.typeLabel.text = @"全";
                self.typeLabel.text = @"保";

                self.typeLabel.textColor = [UIColor colorWithHexString:@"89b1ec"];
            }else{
                self.typeView.image = [UIImage imageNamed:@"payment_weikuan"];
                self.typeLabel.text = @"尾";
                self.typeLabel.textColor = [UIColor colorWithHexString:@"81d49c"];
            }

        }
            break;

        case OrderStatusTypeTHTK:{
            self.typeView.image = [UIImage imageNamed:@"payment_tuikuan"];
            self.typeLabel.text = @"退";
            self.typeLabel.textColor = [UIColor colorWithHexString:@"f68c8d"];
        }
            break;

            
        case OrderStatusTypeTYTHTK:{
            self.typeView.image = [UIImage imageNamed:@"payment_tuikuan"];
            self.typeLabel.text = @"退";
            self.typeLabel.textColor = [UIColor colorWithHexString:@"f68c8d"];
        }
            break;

            
        case OrderStatusTypeJJTHTK:{
            self.typeView.image = [UIImage imageNamed:@"payment_tuikuan"];
            self.typeLabel.text = @"退";
            self.typeLabel.textColor = [UIColor colorWithHexString:@"f68c8d"];
        }
            break;

            
        case OrderStatusTypeMJYTH:{
            self.typeView.image = [UIImage imageNamed:@"payment_tuikuan"];
            self.typeLabel.text = @"退";
            self.typeLabel.textColor = [UIColor colorWithHexString:@"f68c8d"];
        }
            break;

            
        case OrderStatusTypeMJSHTK:{
            self.typeView.image = [UIImage imageNamed:@"payment_weikuan"];
            self.typeLabel.text = @"退";
            self.typeLabel.textColor = [UIColor colorWithHexString:@"81d49c"];
        }
            break;

            
        default:
            break;
    }
    
    
}


- (UIImageView *)typeView{
    if (!_typeView) {
        _typeView = [[UIImageView alloc] init];
    }
    return _typeView;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _typeLabel;
}


- (TTTAttributedLabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _statusLabel.textColor = textNormalColor;
        _statusLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    }
    return _statusLabel;
}

- (UILabel *)fromLabel{
    if (!_fromLabel) {
        _fromLabel = [[UILabel alloc] init];
        _fromLabel.textColor = textLightColor;
        _fromLabel.font = [UIFont systemFontOfSize:12];
    }
    return _fromLabel;
}




//        //如果是卖家
//        if (!_orderList.isBuyer) {
//
//            switch (_orderList.statusId) {
//                case OrderStatusTypeFDJ:
//                    self.leftButton.hidden = YES;
//                     self.rightButton.hidden = NO;
//                    [self.rightButton upateTitle:@"交易信息"];
//                    break;
//
//                case OrderStatusTypeFWK:
//                    self.leftButton.hidden = YES;
//                     self.rightButton.hidden = NO;
//                    [self.rightButton upateTitle:@"交易信息"];
//                    break;
//
//                case OrderStatusTypeQKZF:
//                    self.leftButton.hidden = YES;
//                     self.rightButton.hidden = NO;
//                    [self.rightButton upateTitle:@"交易信息"];
//
//                    break;
//
//                default:
//                    self.leftButton.hidden = YES;
//                    self.rightButton.hidden = YES;
//                    break;
//            }
//
//
//
//        }else{
//
//            switch (_orderList.statusId) {
//                case OrderStatusTypeFDJ:
//                    self.leftButton.hidden = NO;
//                    self.rightButton.hidden = NO;
//                    [self.rightButton upateTitle:@"支付尾款"];
//                    break;
//
//                case OrderStatusTypeFWK:
//                    self.leftButton.hidden = NO;
//                    self.rightButton.hidden = NO;
//                    [self.rightButton upateTitle:@"确认收货"];
//                    break;
//
//                case OrderStatusTypeSQTK:
//                    self.leftButton.hidden = YES;
//                     self.rightButton.hidden = NO;
//                    [self.rightButton upateTitle:_orderList.payOver ? @"确认收货":@"支付尾款"];
//                    break;
//
//                case OrderStatusTypeQKZF:
//                    self.leftButton.hidden = NO;
//                     self.rightButton.hidden = NO;
//                    [self.rightButton upateTitle:@"确认收货"];
//                    break;
//
//                case OrderStatusTypeJJTK:
//                    self.leftButton.hidden = YES;
//                     self.rightButton.hidden = NO;
//                    [self.rightButton upateTitle:@"确认收货"];
//                    break;
//
//                case OrderStatusTypeZDJJTK:
//                    self.leftButton.hidden = YES;
//                     self.rightButton.hidden = NO;
//                    [self.rightButton upateTitle:@"支付尾款"];
//                    break;
//
//                case OrderStatusTypeKFJR:
//                    self.leftButton.hidden = YES;
//                     self.rightButton.hidden = NO;
//                    [self.rightButton upateTitle:@"确认收货"];
//                    break;
//
//                case OrderStatusTypeTHTK:
//                    self.leftButton.hidden = YES;
//                     self.rightButton.hidden = NO;
//                    [self.rightButton upateTitle:_orderList.payOver ? @"确认收货":@"支付尾款"];
//                    break;
//
//                case OrderStatusTypeTYTHTK:
//                    self.leftButton.hidden = YES;
//                     self.rightButton.hidden = NO;
//                    [self.rightButton upateTitle:@"确认收货"];
//                    break;
//
//                case OrderStatusTypeJJTHTK:
//                    self.leftButton.hidden = YES;
//                     self.rightButton.hidden = NO;
//                    [self.rightButton upateTitle:@"确认收货"];
//                    break;
//
//                default:
//                    self.leftButton.hidden = YES;
//                    self.rightButton.hidden = YES;
//                    break;
//            }
//
//        }





@end
