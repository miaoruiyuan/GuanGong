//
//  GGOtherPayDetailPriceCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOtherPayDetailPriceCell.h"

@interface GGOtherPayDetailPriceCell ()

@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *stateLabel;

@end

NSString * const kCellIdentifierOtherPayDetailPrice = @"kGGOtherPayDetailPriceCell";
@implementation GGOtherPayDetailPriceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(22);
            make.height.mas_equalTo(36);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.stateLabel];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-20);
            make.centerY.equalTo(self.contentView);
        }];
        
        
    }
    return self;
}

- (void)setPayDetail:(GGOtherPayDetail *)payDetail{
    if (_payDetail != payDetail) {
        _payDetail = payDetail;
        
        
        self.priceLabel.text = [NSString stringWithFormat:@"- %.2f",[_payDetail.amount floatValue]];
        
        
        NSString *str = nil;
        
        switch (_payDetail.status) {
            case OtherPayStatusDCL:
                str = @"待处理";
                break;
                
            case OtherPayStatusYDF:
                str = @"已代付";
                break;
                
            case OtherPayStatusYJJ:
                str = @"已拒绝";
                break;
                
            case OtherPayStatusYQX:
                str = @"已取消";
                break;
                
            default:
                break;
        }
        
        self.stateLabel.text = str;
        
        
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];    
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = textNormalColor;
        _priceLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightSemibold];
    }
    return _priceLabel;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = themeColor;
        _stateLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    }
    return _stateLabel;
}

@end
