//
//  GGAddressBookCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/5.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGAddressBookCell.h"

@interface GGAddressBookCell ()

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *mobileLabel;

@end

NSString * const kCellIdentifierAddressBook = @"kGGAddressBookCell";

@implementation GGAddressBookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        self.textLabel.font = [UIFont systemFontOfSize:15.2];
        self.detailTextLabel.textColor = textLightColor;
        
        self.accessoryView  = self.addButton;
        
    }
    return self;
}


#pragma mark - init view 

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:15.2];
        _nameLabel.textColor = textNormalColor;
    }
    return _nameLabel;
}

- (UILabel *)mobileLabel{
    if (!_mobileLabel) {
        _mobileLabel = [[UILabel alloc]init];
        _mobileLabel.font = [UIFont systemFontOfSize:12.2];
        _mobileLabel.textColor = textLightColor;
    }
    return _mobileLabel;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(0, 0, 52, 28);
        _addButton.titleLabel.font = [UIFont systemFontOfSize:12.6];
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_addButton setBackgroundColor:themeColor];
    }
    return _addButton;
}

@end
