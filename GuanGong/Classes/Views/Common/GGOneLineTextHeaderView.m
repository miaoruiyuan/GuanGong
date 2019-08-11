
//
//  GGOneLineTextHeaderView.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGOneLineTextHeaderView.h" 

NSString *const kGGOneLineTextHeaderViewID = @"GGOneLineTextHeaderView";

@interface GGOneLineTextHeaderView()

@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation GGOneLineTextHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = tableBgColor;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 12, 0, 0));
        }];
    }
    return self;
}

- (void)showTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

#pragma mark - init View

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    }
    return _titleLabel;
}

@end
