//
//  GGOrderStateCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOrderStateCell.h"

@interface GGOrderStateCell ()

@property(nonatomic,strong)UIImageView *stateView;
@property(nonatomic,strong)UILabel *stateLabel;
@property(nonatomic,strong)UILabel *timeLabel;

@end

NSString * const kCellIdentifierOrderState = @"kGGOrderStateCell";
@implementation GGOrderStateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.stateView];
        [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(18);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        [self.contentView addSubview:self.stateLabel];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stateView.mas_right).offset(10);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(18);
        }];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-18);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(18);
        }];
        
    }
    return self;
}


- (void)setOrderList:(GGOrderList *)orderList
{
    if (_orderList != orderList) {
        _orderList = orderList;
        [self setStatusImageView];
        self.stateLabel.text = orderList.nextStepStatusName;
    }
}

- (void)updateUIWithModel:(GGOrderList *)orderList andReceiptTime:(NSString *)time
{
    self.orderList = orderList;
    
//    if (time) {
//        self.timeLabel.text = time;
//    }else{
//        self.timeLabel.text = @"";
//    }
}

- (void)setStatusImageView
{
    switch (_orderList.statusId) {
        case OrderStatusTypeFDJ:
        case OrderStatusTypeQKZF:
        case OrderStatusTypeFWK:
        case OrderStatusTypeMJQRSH:{
            self.stateView.image = [UIImage imageNamed:@"paymentDetail_wait"];
        }
            break;
            
        case OrderStatusTypeJYCG:
        case OrderStatusTypeTYTK:
        case OrderStatusTypeZDQRSH:
        case OrderStatusTypeMJYTH:
        case OrderStatusTypeMJSHTK:
        case OrderStatusTypeTYTHTK:
        case OrderStatusTypeTKCG:{
            self.stateView.image = [UIImage imageNamed:@"paymentDetail_success"];
        }
            break;
            
            
        case OrderStatusTypeJJTK:
        case OrderStatusTypeJJTHTK:{
            self.stateView.image = [UIImage imageNamed:@"paymentDetail_refuse"];
        }
            break;
            
        case OrderStatusTypeTHTK:
        case OrderStatusTypeSQTK:{
            self.stateView.image = [UIImage imageNamed:@"paymentDetail_redWait"];
        }
            break;
            
        default:
            break;
    }

}


//switch (_orderList.statusId) {
//    case OrderStatusTypeFDJ:{
//        self.stateView.image = [UIImage imageNamed:@"paymentDetail_wait"];
//    }
//        break;
//        
//    case OrderStatusTypeFWK:{
//        self.stateView.image = [UIImage imageNamed:@"paymentDetail_wait"];
//    }
//        break;
//        
//    case OrderStatusTypeJYCG:{
//        self.stateView.image = [UIImage imageNamed:@"paymentDetail_success"];
//    }
//        break;
//        
//    case OrderStatusTypeSQTK:{
//        self.stateView.image = [UIImage imageNamed:@"paymentDetail_redWait"];
//    }
//        break;
//        
//    case OrderStatusTypeTKCG:{
//        self.stateView.image = [UIImage imageNamed:@"paymentDetail_success"];
//    }
//        break;
//        
//    case OrderStatusTypeQKZF:{
//        self.stateView.image = [UIImage imageNamed:@"paymentDetail_wait"];
//    }
//        break;
//        
//    case OrderStatusTypeJJTK:{
//        self.stateView.image = [UIImage imageNamed:@"paymentDetail_refuse"];
//    }
//        break;
//        
//    case OrderStatusTypeTYTK:{
//        self.stateView.image = [UIImage imageNamed:@"paymentDetail_success"];
//    }
//        break;
//        
//    case OrderStatusTypeZDQRSH:{
//        self.stateView.image = [UIImage imageNamed:@"paymentDetail_success"];
//    }
//        break;
//        
//    case OrderStatusTypeTHTK:{
//        self.stateView.image = [UIImage imageNamed:@"paymentDetail_redWait"];
//    }
//        break;
//        
//    case OrderStatusTypeTYTHTK:{
//        self.stateView.image = [UIImage imageNamed:@"paymentDetail_success"];
//    }
//        break;
//        
//    case OrderStatusTypeJJTHTK:{
//        self.stateView.image = [UIImage imageNamed:@"paymentDetail_refuse"];
//    }
//        break;
//        
//    case OrderStatusTypeMJYTH:{
//        self.stateView.image = [UIImage imageNamed:@"paymentDetail_success"];
//    }
//        break;
//        
//    case OrderStatusTypeMJSHTK:{
//        self.stateView.image = [UIImage imageNamed:@"paymentDetail_success"];
//    }
//        break;
//        
//    case OrderStatusTypeMJQRSH:{
//        self.stateView.image = [UIImage imageNamed:@"paymentDetail_wait"];
//    }
//        break;
//        
//    default:
//        break;
//}


- (UIImageView *)stateView{
    if (!_stateView) {
        _stateView = [[UIImageView alloc] init];
    }
    return _stateView;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _stateLabel.textColor = textNormalColor;
        
    }
    return _stateLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = themeColor;
        
    }
    return _timeLabel;
}


@end
