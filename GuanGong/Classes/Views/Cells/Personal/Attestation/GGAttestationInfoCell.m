//
//  GGAttestationInfoCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/5.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGAttestationInfoCell.h"

@interface GGAttestationInfoCell()
{
    
}

@property (nonatomic,strong)UIView *lineView;

@end

NSString *const kGGAttestationInfoCellID = @"GGAttestationInfoCell";

@implementation GGAttestationInfoCell

@synthesize titleLabel = _titleLabel;


- (void)setupView{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(15);
    }];
    
    [self.contentView addSubview:self.inputTextField];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(14);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.inputTextField becomeFirstResponder];
    }
    // Configure the view for the selected state
}

- (void)configItem:(GGFormItem *)item
{
    self.titleLabel.text = item.title;
//    self.inputTextField.placeholder = [NSString stringWithFormat:@"请输入%@",item.title];
    self.inputTextField.text = item.obj;
    if (item.pageContent) {
        self.inputTextField.keyboardType = [(GGPersonalInput *)item.pageContent keyBoardType];
    }
    
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = textLightColor;
    }
    return _titleLabel;
}

- (UITextField *)inputTextField
{
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.font = [UIFont boldSystemFontOfSize:15];
        _inputTextField.textAlignment = NSTextAlignmentCenter;
        _inputTextField.textColor = [UIColor blackColor];
        _inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _inputTextField;
}

-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = sectionColor;
    }
    return _lineView;
}

@end
