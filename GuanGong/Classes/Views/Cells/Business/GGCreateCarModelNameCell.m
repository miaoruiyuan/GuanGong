//
//  GGCreateCarModelNameCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/2.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGCreateCarModelNameCell.h"

@interface GGCreateCarModelNameCell ()

@property(nonatomic,strong)UILabel *valueLabel;

@end

NSString *const kGGCreateCarModelNameCellID = @"GGCreateCarModelNameCell";

@implementation GGCreateCarModelNameCell

- (void)setupView{
    
    [super setupView];
    
    [self.contentView addSubview:self.valueLabel];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.arrowView.mas_left).offset(-2);
        make.left.equalTo(self.titleLabel.mas_right).offset(14);
        make.height.mas_equalTo(self.titleLabel);
    }];
}

- (void)configItem:(GGFormItem *)item
{
    [super configItem:item];
    self.valueLabel.text = item.obj;
}

- (UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = textLightColor;
        _valueLabel.numberOfLines = 0;
        _valueLabel.preferredMaxLayoutWidth = kScreenWidth - 120;
        _valueLabel.textAlignment = NSTextAlignmentRight;
        _valueLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    }
    return _valueLabel;
}

@end
