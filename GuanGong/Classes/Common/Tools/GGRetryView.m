//
//  GGRetryView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGRetryView.h"

@interface GGRetryView ()

@property(nonatomic,strong)UIView *inView;
@property(nonatomic,strong)UIImageView *icoImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)GGButton *button;

@end


@implementation GGRetryView


-(instancetype)initRetryInView:(UIView *)inView ico:(NSString *)ico title:(NSString *)title size:(CGFloat)size offsetY:(CGFloat)offsetY{
    if (self = [super init]) {
        self.inView = inView;
        self.bgView.frame = inView.bounds;
        [self.inView addSubview:self.bgView];
        
        [self.bgView addSubview:self.icoImage];
        [self.icoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView.mas_centerY).offset(-10 + offsetY);
            make.centerX.equalTo(inView.mas_centerX).offset(0);
        }];
        
        [self.bgView addSubview:self.descLabel];
        self.descLabel.font = [UIFont systemFontOfSize:size];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView.mas_centerY).offset(10 + offsetY);
            make.centerX.equalTo(inView.mas_centerX).offset(0);
        }];
        
        self.icoImage.image = [UIImage imageNamed:ico];
        self.descLabel.text = title;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchRetryAction)];
        [self.bgView addGestureRecognizer:tap];
        [self dismiss];
    }
    return self;
}
-(instancetype)initRouteInView:(UIView *)inView title:(NSString *)title desc:(NSString *)desc btnTitle:(NSString *)btnTitle offsetY:(CGFloat)offsetY{
    if (self = [super init]) {
        self.inView = inView;
        self.bgView.frame = inView.bounds;
        [self.inView addSubview:self.bgView];
        
        [self.bgView addSubview:self.descLabel];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bgView.mas_centerY).offset(offsetY);
            make.centerX.equalTo(self.bgView.mas_centerX).offset(0);
            make.left.equalTo(self.bgView.mas_left).offset(46);
            make.right.equalTo(self.bgView.mas_right).offset(-46);
        }];
        
        [self.bgView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.descLabel.mas_top).offset(-21);
            make.centerX.equalTo(self.bgView.mas_centerX).offset(0);
        }];
        
        self.button = [[GGButton alloc] initWithButtonTitle:title style:GGButtonStyleHollow size:14];
        [self.button addTarget:self action:@selector(clickRouteAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView.mas_centerX).offset(0);
            make.top.equalTo(self.descLabel.mas_bottom).offset(40);
            make.size.mas_equalTo(CGSizeMake(125, 30));
        }];
        
        self.titleLabel.text = title;
        self.descLabel.text = desc;
        [self.button setTitle:btnTitle forState:UIControlStateNormal];
        [self dismiss];
    }
    return self;
}
-(void)clickRouteAction{
    if (self.clickRoute) self.clickRoute();
}
-(void)touchRetryAction{
    [self dismiss];
    if (self.touchRetry) self.touchRetry();
}
-(void)show{
    self.bgView.hidden = NO;
}
-(void)dismiss{
    self.bgView.hidden = YES;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    }
    return _bgView;
}
-(UIImageView *)icoImage{
    if (!_icoImage) {
        _icoImage = [[UIImageView alloc] init];
    }
    return _icoImage;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel.font = [UIFont systemFontOfSize:27];
        _titleLabel.textColor = [UIColor colorWithHexString:@"808080"];
    }
    return _titleLabel;
}
-(UILabel *)descLabel{
    if (!_descLabel) {        
        _descLabel.font = [UIFont systemFontOfSize:17];
        _descLabel.numberOfLines = 0;
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.textColor = [UIColor colorWithHexString:@"808080"];
        
    }
    return _descLabel;
}


@end
