//
//  GGInputOnlyTextPlainCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/20.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGInputOnlyTextPlainCell.h"

@interface GGInputOnlyTextPlainCell ()

@property (strong, nonatomic) NSString *phStr, *valueStr;
@property (assign,nonatomic) BOOL isSecure;
@end

NSString * const kCellIdentifierInputOnlyTextPlain = @"kGGInputOnlyTextPlainCell";
@implementation GGInputOnlyTextPlainCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_textField) {
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(kLeftPadding, 7.0, kScreenWidth-16*2, 30)];
            _textField.backgroundColor = [UIColor clearColor];
            _textField.borderStyle = UITextBorderStyleNone;
            _textField.textColor = textNormalColor;
            _textField.font = [UIFont systemFontOfSize:14.8];
            [_textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
            _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [self.contentView addSubview:_textField];
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_phStr? _phStr: @"" attributes:@{}];
    _textField.text = _valueStr;
    _textField.secureTextEntry = _isSecure;
}

- (void)configWithPlaceholder:(NSString *)phStr valueStr:(NSString *)valueStr secureTextEntry:(BOOL)isSecure{
    self.phStr = phStr;
    self.valueStr = valueStr;
    self.isSecure = isSecure;
}
- (void)textValueChanged:(id)sender {
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(self.textField.text);
    }
}



@end
