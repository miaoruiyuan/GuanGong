//
//  GGCarYearCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarYearCell.h"

@interface GGCarYearCell ()
@property(nonatomic,strong)UILabel *yearLabel;

@end

NSString *const kCellIdentifierCreateCarYear = @"kGGCarYearCell";
@implementation GGCarYearCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.yearLabel];
        [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(20);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}


- (void)setYear:(NSString *)year{
    if (_year != year) {
        _year = year;
        
        self.yearLabel.text = _year;
    }
}

- (UILabel *)yearLabel{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] init];
        _yearLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
        _yearLabel.textColor = textNormalColor;
    }
    return _yearLabel;
}


@end
