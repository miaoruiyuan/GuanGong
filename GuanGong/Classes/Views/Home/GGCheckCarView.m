//
//  GGCheckCarView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckCarView.h"

@interface GGCheckCarView ()
@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation GGCheckCarView

- (id)init{
    if (self = [super init]) {
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(30);
            make.centerX.equalTo(self);
        }];
        
        [self addSubview:self.priceButton];
        [self.priceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
            make.centerX.equalTo(self.titleLabel);
            
        }];
        
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"checkCar_bg"];
    [image drawInRect:CGRectMake(0, 0, kScreenWidth - 24, 120)
      withContentMode:UIViewContentModeScaleToFill
        clipsToBounds:NO];
    
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"好车伯乐检测";
    }
    return _titleLabel;
}

- (UIButton *)priceButton{
    if (!_priceButton) {
        _priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_priceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_priceButton setTitle:@"查看价格表" forState:UIControlStateNormal];
        [_priceButton.titleLabel setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular]];
        [_priceButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [_priceButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -130)];
        [_priceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    }
    return _priceButton;
}

@end
