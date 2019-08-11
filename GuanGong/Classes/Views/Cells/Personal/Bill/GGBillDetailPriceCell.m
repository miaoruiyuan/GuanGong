//
//  GGBillDetailPriceCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBillDetailPriceCell.h"

@interface GGBillDetailPriceCell ()

@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *stateLabel;



@end

NSString * const  kCellIdentifierBillDetailPrice = @"kGGBillDetailPriceCell";
@implementation GGBillDetailPriceCell

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

//- (void)setBillList:(GGBillList *)billList{
//    if (_billList != billList) {
//        _billList = billList;
//        
//        
//        if ([_billList.tranFlag isEqualToNumber:@1]) {
//            self.priceLabel.text = [NSString stringWithFormat:@"-%@",[NSString positiveFormat:_billList.tranAmount]];
//            self.priceLabel.textColor = [UIColor colorWithHexString:@"#FB8638"];
//
//        }else{
//            self.priceLabel.text = [NSString stringWithFormat:@"+%@",[NSString positiveFormat:_billList.tranAmount]];
//            self.priceLabel.textColor = [UIColor colorWithHexString:@"#3bbd79"];
//        }
//        
//        
//
//        
//        self.stateLabel.text = _billList.dealTypeName;
//        
//    }
//}


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
