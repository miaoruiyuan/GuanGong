//
//  GGTitleDisclosureCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTitleDisclosureCell.h"

@interface GGTitleDisclosureCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSString *title;
@end

NSString * const kCellIdentifierTitleDisclosure = @"kGGTitleDisclosureCell";
@implementation GGTitleDisclosureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor whiteColor];
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPadding, 7, (kScreenWidth - 120), 30)];
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.font = [UIFont systemFontOfSize:15];
            _titleLabel.textColor = [UIColor blackColor];
            [self.contentView addSubview:_titleLabel];
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.text = _title;
}

- (void)setTitleStr:(NSString *)title{
    self.title = title;
}


@end
