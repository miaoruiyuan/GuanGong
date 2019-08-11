//
//  CWTAssessHistoryCell.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/5/3.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTAssessHistoryCell.h"

NSString *const kCellIdentifierAssessHistory = @"kCWTAssessHistoryCell";

@implementation CWTAssessHistoryCell

- (void)setupView{
    
    [super setupView];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    [self.bottomConstraint uninstall];
    [self.contentView addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.line.mas_bottom).offset(61);
        make.height.mas_equalTo(.6);        
    }];
    
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLine.mas_bottom).offset(10);
        make.left.equalTo(self.bottomLine);
        make.height.mas_equalTo(12);
       self.bottomConstraint =  make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
}

- (void)configItemWithObj:(CWTAssess *)obj{
    [super configItemWithObj:obj];
    
    self.dateLabel.text = obj.update_time;
}


- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        _dateLabel.font = [UIFont systemFontOfSize:11];
    }
    return _dateLabel;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"eaedef"];
    }
    return _bottomLine;
}

@end
