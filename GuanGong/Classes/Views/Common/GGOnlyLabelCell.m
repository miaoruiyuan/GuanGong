//
//  GGOnlyLabelCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/23.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOnlyLabelCell.h"

NSString *const kCellIdentifierOnlyLabel = @"kGGOnlyLabelCell";

@implementation GGOnlyLabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(12, 14, 12, 14));
        }];
    }
    return self;
}


- (void)updateHelpListTitle:(NSString *)title
{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.label.text = title;
    self.label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
}

#pragma mark - init View

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.font = [UIFont systemFontOfSize:15.6 weight:UIFontWeightRegular];
        _label.textColor = textNormalColor;
        _label.numberOfLines = 0;
    }
    return _label;
}

@end
