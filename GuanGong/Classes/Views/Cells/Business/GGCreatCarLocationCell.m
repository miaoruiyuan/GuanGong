//
//  GGCreatCarLocationCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/3.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCreatCarLocationCell.h"

@interface GGCreatCarLocationCell ()

@property(nonatomic,strong)UIImageView *iconView;

@property(nonatomic,strong)UILabel *addressLabel;

@end

NSString *const kCellIdentifierCreateCarLocation = @"kGGCreatCarLocationCell";

@implementation GGCreatCarLocationCell

- (void)setupView{
    [super setupView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(13, 17));
        make.top.greaterThanOrEqualTo(@16);
    }];
    
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.right.equalTo(self.arrowView.mas_left).offset(-12);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
    }];
}

- (void)configItem:(GGFormItem *)item
{
    self.addressLabel.text = item.obj ? [NSString stringWithFormat:@"%@ %@\n%@%@%@",
                                         [item.obj valueForKey:@"contactName"],
                                         [item.obj valueForKey:@"contactTel"],
                                         [item.obj valueForKey:@"provinceStr"],
                                         [item.obj valueForKey:@"cityStr"],
                                         [item.obj valueForKey:@"contactAddress"]]: nil;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"address_map"];
    }
    return _iconView;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.numberOfLines =  0;
        _addressLabel.textColor = textLightColor;
        _addressLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    }
    return _addressLabel;
}

@end
