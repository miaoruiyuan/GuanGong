//
//  GGCompanyCodeCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/7.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGCompanyCodeCell.h"

NSString *const kGGCompanyCodeCellID = @"GGCompanyCodeCell";

@interface GGCompanyCodeCell()
{
    
}

@property (nonatomic,strong)UIView *topLineView;
@property (nonatomic,strong)UIView *bottomLineView;

@end


@implementation GGCompanyCodeCell

- (void)setupView{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.topLineView];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.contentView addSubview:self.titleBtn];
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(32);
    }];
    
    [self.contentView addSubview:self.inputTextField];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(14);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)configItem:(GGFormItem *)item
{
    [self.titleBtn setTitle:item.title forState:UIControlStateNormal];
    [self.titleBtn layoutIfNeeded];
    [self.titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
    [self.titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleBtn.titleLabel.bounds.size.width + 2, 0, -self.titleBtn.titleLabel.bounds.size.width - 2)];
//    
//    self.inputTextField.placeholder = [NSString stringWithFormat:@"请输入%@",item.title];
    self.inputTextField.text = item.obj;
    self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
}

#pragma mark - init View

- (UIButton *)titleBtn
{
    if (!_titleBtn) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleBtn setTitleColor:textLightColor forState:UIControlStateNormal];
        [_titleBtn setImage:[UIImage imageNamed:@"btn_image_pull_down_n"] forState:UIControlStateNormal];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleBtn;
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

- (UIView *)topLineView
{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = sectionColor;
    }
    return _topLineView;
}

- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = sectionColor;
    }
    return _bottomLineView;
}

@end
