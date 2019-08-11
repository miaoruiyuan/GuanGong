
//
//  GGOtherPayCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOtherPayCell.h"
#import "TTTAttributedLabel.h"

@interface GGOtherPayCell ()

@property(nonatomic,strong)TTTAttributedLabel *describeLabel;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UIImageView *stateView;



@end

NSString * const kCellIdentifierOtherPay = @"kGGOtherPayCell";
@implementation GGOtherPayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    
        [self.contentView addSubview:self.describeLabel];
        [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.top.equalTo(self.contentView.mas_top).offset(20);
            make.height.mas_equalTo(18);
        }];
        
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.describeLabel);
            make.top.equalTo(self.describeLabel.mas_bottom).offset(12);
            make.height.mas_equalTo(14);
        }];
        
        [self.contentView addSubview:self.stateView];
        [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.contentView).with.offset(-5);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        
    }
    return self;
}




- (void)setOtherPayList:(GGOtherPayList *)otherPayList{
    if (_otherPayList != otherPayList) {
        _otherPayList = otherPayList;
        
        
    
        NSString *payerName = _otherPayList.payer.realName;
        NSString *buyerName = _otherPayList.buyer.realName;
        CGFloat price = [_otherPayList.amount floatValue];
        
        
        if (self.isMineApply) {
            [self.describeLabel setText:[NSString stringWithFormat:@"申请%@为您代付%.2f元",payerName,price] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                
                NSRange markRangeName = [[mutableAttributedString string] rangeOfString:payerName options:NSCaseInsensitiveSearch];
                [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName: textNormalColor,NSFontAttributeName : [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]} range:markRangeName];
                
                NSRange markRangePrice = [[mutableAttributedString string] rangeOfString:[NSString stringWithFormat:@"%.2f",price] options:NSCaseInsensitiveSearch];
                [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName: themeColor,NSFontAttributeName : [UIFont systemFontOfSize:16 weight:UIFontWeightRegular]} range:markRangePrice];
                
                
                return mutableAttributedString;
                
            }];

        }else{
            
        
            [self.describeLabel setText:[NSString stringWithFormat:@"%@申请您代付%.2f元",buyerName,price] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                
                NSRange markRangeName = [[mutableAttributedString string] rangeOfString:buyerName options:NSCaseInsensitiveSearch];
                [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName: textNormalColor,NSFontAttributeName : [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]} range:markRangeName];
                
                NSRange markRangePrice = [[mutableAttributedString string] rangeOfString:[NSString stringWithFormat:@"%.2f",price] options:NSCaseInsensitiveSearch];
                [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName: themeColor,NSFontAttributeName : [UIFont systemFontOfSize:16 weight:UIFontWeightRegular]} range:markRangePrice];
                return mutableAttributedString;
                
            }];

            
        }
        
        
        
        self.dateLabel.text = _otherPayList.createTimeStr;
        
        
        
        switch (_otherPayList.status) {
            case OtherPayStatusDCL:
                self.stateView.image = [UIImage imageNamed:@"otherPay_dcl"];
                break;
                
            case OtherPayStatusYDF:
                self.stateView.image = [UIImage imageNamed:@"otherPay_ydf"];
                break;

                
            case OtherPayStatusYJJ:
                self.stateView.image = [UIImage imageNamed:@"otherPay_yjj"];
                break;

                
            case OtherPayStatusYQX:
                self.stateView.image = [UIImage imageNamed:@"otherPay_yqx"];
                break;

                
            default:
                break;
        }
        
        
        
    }
}



- (TTTAttributedLabel *)describeLabel{
    if (!_describeLabel) {
        _describeLabel = [TTTAttributedLabel new];
        _describeLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _describeLabel.textColor = textLightColor;
    }
    return _describeLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _dateLabel.textColor = [UIColor colorWithHexString:@"8e8e8e"];
    }
    return _dateLabel;
}

- (UIImageView *)stateView{
    if (!_stateView) {
        _stateView = [[UIImageView alloc] init];
    }
    return _stateView;
}



@end
