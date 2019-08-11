//
//  GGTableHeaderFooterView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableHeaderFooterView.h"

NSString *const kViewIdentifierHeaderFooterView = @"kGGTableHeaderFooterView";

@interface GGTableHeaderFooterView ()

@property(nonatomic,strong)UILabel *label;

@end

@implementation GGTableHeaderFooterView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = tableBgColor;
        
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, kLeftPadding, 0, 0));
        }];
    }
    return self;
}


- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textColor = textLightColor;
        _label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    }
    return _label;
}

- (void)setTitle:(NSString *)title{
    if (_title != title) {
        _title = title;
        self.label.text = title;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
