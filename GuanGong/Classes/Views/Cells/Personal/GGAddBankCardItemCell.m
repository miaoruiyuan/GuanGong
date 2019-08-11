//
//  GGAddBankCardItemCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/3/2.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGAddBankCardItemCell.h"

NSString * const kGGAddBankCardItemCellID = @"GGAddBankCardItemCell";

@interface GGAddBankCardItemCell()
{
    
}

@property (nonatomic,strong)UILabel *leftTitleLable;
@property (nonatomic,strong)GGFormItem *model;

@end

@implementation GGAddBankCardItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


-(void)setupView
{
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(16);
        make.size.mas_equalTo(CGSizeMake(70, 40));
    }];
    
    [self.contentView addSubview:self.inputTextField];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-22);
        make.height.mas_equalTo(40);
    }];
}

- (void)configItem:(GGFormItem *)item
{
    self.titleLabel.text = item.title;
    
    if ([item.pageContent isKindOfClass:[GGPersonalInput class]]) {
        self.inputTextField.placeholder = [(GGPersonalInput *)item.pageContent placeholder];
    }
}

- (void)configItemShowRight:(GGFormItem *)item
{
    self.inputTextField.rightViewMode = UITextFieldViewModeAlways;
    self.inputTextField.placeholder = @"如6.2";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 24)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = textLightColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"万公里";
    self.inputTextField.rightView = label;
    self.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self configItem:item];
}

- (UILabel *)leftTitleLable
{
    if (!_leftTitleLable) {
        _leftTitleLable = [UILabel new];
        _leftTitleLable.font = [UIFont systemFontOfSize:15.2];
        _leftTitleLable.textColor = [UIColor blackColor];
    }
    return _leftTitleLable;
}

- (UITextField *)inputTextField
{
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.font = [UIFont systemFontOfSize:15.2];
        _inputTextField.textAlignment = NSTextAlignmentRight;
        _inputTextField.textColor = [UIColor darkGrayColor];
        _inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _inputTextField;
}


@end
