//
//  GGTitleTextFieldCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/16.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTitleTextFieldCell.h"

NSString *const kCellIdentifierTitleTextField = @"kGGTitleTextFieldCell";

@interface GGTitleTextFieldCell ()

@end

@implementation GGTitleTextFieldCell

- (void)setupView{
    [super setupView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.contentView addSubview:self.inputFiled];
    [self.inputFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(12);
        make.centerY.equalTo(self.titleLabel);
        make.height.mas_equalTo(19);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        
    }];
}

- (UITextField *)inputFiled{
    if (!_inputFiled) {
        _inputFiled = [[UITextField alloc]init];
        _inputFiled.textColor = textNormalColor;
        _inputFiled.keyboardType = UIKeyboardTypeNumberPad;
        _inputFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputFiled.font = [UIFont systemFontOfSize:16];
    }
    return _inputFiled;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
