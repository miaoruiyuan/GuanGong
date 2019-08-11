//
//  GGCreatCarNormalCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCreatCarNormalCell.h"

@interface GGCreatCarNormalCell ()

@property(nonatomic,strong)UILabel *valueLabel;

@end

NSString *const kCellIdentifierCreateCarNormal = @"kJGBCreatCarNormalCell";

@implementation GGCreatCarNormalCell

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

- (void)configItem:(GGFormItem *)item{
    [super configItem:item];
    self.valueLabel.text = item.obj;
}

- (UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = textLightColor;
        _valueLabel.textAlignment = NSTextAlignmentRight;
        _valueLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    }
    return _valueLabel;
}

@end
