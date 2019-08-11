//
//  GGTextFieldButtonCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/3.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTextFieldButtonCell.h"


@interface GGTextFieldButtonCell ()

@end

NSString * _Nullable const kCellIdentifierTextFieldButton = @"GGTextFieldButtonCell";

@implementation GGTextFieldButtonCell

- (void)setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(kLeftPadding, 9, kScreenWidth - 150, 26)];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = [UIFont systemFontOfSize:15.2];
        _textField.textColor = textNormalColor;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [self.contentView addSubview:_textField];
    }
    
    if (!_sendbutton) {
        _sendbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendbutton.frame = CGRectMake(kScreenWidth - 100 - kLeftPadding, 7, 100, 30);
        [_sendbutton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        [_sendbutton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendbutton.titleLabel.font = [UIFont systemFontOfSize:13.5 weight:UIFontWeightLight];
        _sendbutton.layer.masksToBounds = YES;
        _sendbutton.layer.cornerRadius = 2;
        [self.contentView addSubview:_sendbutton];
    }
}

- (void)configItem:(GGFormItem *)item
{
    _textField.placeholder = [(GGPersonalInput *)item.pageContent placeholder];
}

@end
