//
//  GGEditAddressCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGEditAddressCell.h"

@interface GGEditAddressCell ()

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIButton *editButton;
@property(nonatomic,strong)UIButton *deleteButton;
@property(nonatomic,strong)UIButton *setDefultButton;

@end

NSString * const kCellIdentifierEditAddress = @"kGGEditAddressCell";

@implementation GGEditAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.width = kScreenWidth;

        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(14);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.height.mas_offset(16);
        }];
        
        [self.contentView addSubview:self.phoneLabel];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).offset(10);
            make.top.height.equalTo(self.nameLabel);
        }];
        
        [self.contentView addSubview:self.addressLabel];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.addressLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(.5);
        }];
        
        [self.contentView addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line.mas_bottom).offset(6);
            make.right.equalTo(self.addressLabel);
            make.size.mas_equalTo(CGSizeMake(80, 22));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
        }];
        
        [self.contentView addSubview:self.editButton];
        [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.deleteButton.mas_left).offset(-10);
            make.size.top.equalTo(self.deleteButton);
        }];
    
        [self.contentView addSubview:self.setDefultButton];
        [self.setDefultButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addressLabel);
            make.centerY.equalTo(self.editButton);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self bindingAction];
    }
    return self;
}

- (void)bindingAction
{
    @weakify(self);
    [[self.setDefultButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
        @strongify(self);
        if (self.setDefultAddressBlock) {
            self.setDefultAddressBlock();
        }
    }];

    [[self.editButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (self.editAddressBlock) {
            self.editAddressBlock();
        }
    }];
    
    [[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (self.deteleAdressBlock) {
            self.deteleAdressBlock();
        }
    }];
}

- (void)setAddress:(GGAddress *)address
{
    _address = address;
    
    self.nameLabel.text = _address.contactName;
    self.phoneLabel.text = _address.contactTel;
    
    NSString *addressString = nil;
    if ([_address.cityStr containsString:_address.provinceStr]) {
        addressString = [NSString stringWithFormat:@"%@%@",_address.cityStr,_address.contactAddress];
    }else{
        addressString = [NSString stringWithFormat:@"%@%@%@",_address.provinceStr,_address.cityStr,_address.contactAddress];
    }
    
    self.addressLabel.text = addressString;
    
    if (_address.isDefault) {
        self.setDefultButton.enabled = NO;
    }else{
        self.setDefultButton.enabled = YES;
    }
}

#pragma mark - init View

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
        _nameLabel.textColor = [UIColor colorWithHexString:@"000000"];
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
        _phoneLabel.textColor = [UIColor colorWithHexString:@"000000"];
    }
    return _phoneLabel;
}


- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.numberOfLines = 0;
        _addressLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
        _addressLabel.preferredMaxLayoutWidth = kScreenWidth - 30;
        _addressLabel.textColor = [UIColor colorWithHexString:@"000000"];
    }
    return _addressLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    }
    return _line;
}

- (UIButton *)editButton{
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitleColor:[UIColor colorWithHexString:@"737373"] forState:UIControlStateNormal];
        [_editButton.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightThin]];
        [_editButton setImage:[UIImage imageNamed:@"edit_address"] forState:UIControlStateNormal];
        [_editButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    return _editButton;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor colorWithHexString:@"737373"] forState:UIControlStateNormal];
        [_deleteButton.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightThin]];
        [_deleteButton setImage:[UIImage imageNamed:@"delete_address"] forState:UIControlStateNormal];
        [_deleteButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    return _deleteButton;
}

- (UIButton *)setDefultButton{
    if (!_setDefultButton) {
        _setDefultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setDefultButton setTitle:@"默认地址" forState:UIControlStateNormal];
        [_setDefultButton setTitleColor:themeColor forState:UIControlStateNormal];
        [_setDefultButton.titleLabel setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightThin]];
        [_setDefultButton setImage:[UIImage imageNamed:@"select_circle"] forState:UIControlStateDisabled];
        [_setDefultButton setImage:[UIImage imageNamed:@"unselect_circle"] forState:UIControlStateNormal];
        [_setDefultButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 0)];
        [_setDefultButton setImageEdgeInsets:UIEdgeInsetsMake(0, -28, 0, 0)];
    }
    return _setDefultButton;
}


@end
