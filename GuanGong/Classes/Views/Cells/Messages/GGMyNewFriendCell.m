//
//  GGMyNewFriendCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMyNewFriendCell.h"

NSString * const kCellIdentifierMyNewFeiend = @"kGGMyNewFriendCell";

@interface GGMyNewFriendCell ()

@property (nonatomic,strong) UILabel *addStatusLabel;

@end

@implementation GGMyNewFriendCell

- (void)setUpView{
    [super setUpView];
    
    [self.contentView addSubview:self.stateButton];
    [self.stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(50, 26));
    }];
    
    [self.contentView addSubview:self.addStatusLabel];
    [self.addStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(50, 26));
    }];
}

- (void)setList:(GGFriendsList *)list{
    [super setList:list];
    
    if ([list.statusId isEqualToNumber:@3]) {
        self.stateButton.hidden = YES;
        self.addStatusLabel.hidden = NO;
    }else{
        self.stateButton.hidden = NO;
        self.addStatusLabel.hidden = YES;
    }
}

- (UIButton *)stateButton{
    if (!_stateButton) {
        _stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stateButton.titleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular]];
        [_stateButton setTitleColor:textNormalColor forState:UIControlStateNormal];
        [_stateButton setBackgroundImage:[UIImage imageWithColor:tableBgColor] forState:UIControlStateNormal];
        [_stateButton setTitle:@"添加" forState:UIControlStateNormal];
        _stateButton.layer.masksToBounds = NO;
        _stateButton.layer.cornerRadius = 2;
        _stateButton.layer.borderWidth = 0.5f;
        _stateButton.layer.borderColor = sectionColor.CGColor;
    }
    return _stateButton;
}

- (UILabel *)addStatusLabel
{
    if (!_addStatusLabel) {
        _addStatusLabel = [[UILabel alloc] init];
        _addStatusLabel.text = @"已添加";
        _addStatusLabel.textAlignment = NSTextAlignmentCenter;
        _addStatusLabel.font = [UIFont systemFontOfSize:13];
        _addStatusLabel.textColor = sectionColor;
    }
    return _addStatusLabel;
}


@end
