//
//  GGTextFileldCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/3.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTextFileldCell.h"


@interface GGTextFileldCell ()

@end

NSString * const kCellIdentifierTextField = @"kGGTextFileldCell";

@implementation GGTextFileldCell

- (void)setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(kLeftPadding, 7, kScreenWidth - kLeftPadding*2, 30)];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = [UIFont systemFontOfSize:15.2];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.textColor = textNormalColor;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:_textField];
    }
}

- (void)configItem:(GGFormItem *)item
{
    _textField.placeholder = [(GGPersonalInput *)item.pageContent placeholder];
}

- (void)showTitle:(NSString *)title AndPlaceholder:(NSString *)placeholder
{
    _textField.placeholder = placeholder;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    textLabel.font = [UIFont systemFontOfSize:15.2];
    textLabel.textColor = [UIColor darkTextColor];
    textLabel.text = title;
    _textField.leftView = textLabel;
    _textField.leftViewMode = UITextFieldViewModeAlways;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
//_textFiled.placeholder = self.placeHolderText;

}


@end
