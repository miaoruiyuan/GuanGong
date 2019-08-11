//
//  GGCarAddressCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarAddressCell.h"
#import "TTTAttributedLabel.h"

@interface GGCarAddressCell ()

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)TTTAttributedLabel *addressLabel;

@end

NSString *const kCellIdentifierCarAddress = @"kGGCarAddressCell";

@implementation GGCarAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(14);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.height.mas_offset(16);
        }];
        
        [self.contentView addSubview:self.phoneLabel];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.height.mas_offset(16);
        }];
        
        [self.contentView addSubview:self.addressLabel];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset(14);
            make.right.equalTo(self.contentView.mas_right).offset(-12);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-12).priority(710);
        }];
        
        self.tintColor = themeColor;
    }
    return self;
}

- (void)setAddress:(GGAddress *)address{
    _address = address;
    

    self.nameLabel.text = _address.contactName;
    self.phoneLabel.text = _address.contactTel;    
   
    if (_address.isDefault) {
        [self.addressLabel setText:[NSString stringWithFormat:@"[默认]  %@",_address.contactAddress] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange markRange = [[mutableAttributedString string] rangeOfString:@"[默认]" options:NSCaseInsensitiveSearch];
            [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName:textNormalColor,NSFontAttributeName : [UIFont systemFontOfSize:14 weight:UIFontWeightRegular]} range:markRange];
            return mutableAttributedString;
        }];
    } else {
        [self.addressLabel setText:_address.contactAddress];
    }
    
    if (_address.isListSelected) {
        self.nameLabel.textColor = themeColor;
        self.phoneLabel.textColor = themeColor;
        self.phoneLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.nameLabel.textColor = textNormalColor;
        self.phoneLabel.textColor = textNormalColor;
        self.phoneLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightThin];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _nameLabel.highlightedTextColor = themeColor;
        _nameLabel.textColor = textNormalColor;
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightThin];
        _phoneLabel.highlightedTextColor = themeColor;
        _phoneLabel.textColor = textNormalColor;
    }
    return _phoneLabel;
}


- (TTTAttributedLabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [TTTAttributedLabel new];
        _addressLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
        _addressLabel.textColor = textLightColor;
        _addressLabel.numberOfLines = 0;
        _addressLabel.preferredMaxLayoutWidth = kScreenWidth - 26;
    }
    return _addressLabel;
}


@end
