//
//  GGAccountView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/3.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGAccountView.h"

@interface GGAccountView ()

@property(nonatomic,strong)UIImageView *faceImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *phoneLabel;

@end

@implementation GGAccountView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        if (!_faceImageView) {
            _faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.origin.y + 30, 60, 60)];
            _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
            _faceImageView.clipsToBounds = YES;
            _faceImageView.centerX = self.centerX;
            [self addSubview:_faceImageView];
        }
        
        if (!_nameLabel) {
            _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _faceImageView.bottom + 12, 200, 20)];
            _nameLabel.textAlignment = NSTextAlignmentCenter;
            _nameLabel.font = [UIFont systemFontOfSize:18];
            _nameLabel.textColor = textNormalColor;
            _nameLabel.centerX = _faceImageView.centerX;
            [self addSubview:_nameLabel];
        }
        
        if (!_phoneLabel) {
            _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _nameLabel.bottom + 12, 190, 18)];
            _phoneLabel.textColor = textLightColor;
            _phoneLabel.font = [UIFont systemFontOfSize:14];
            _phoneLabel.textAlignment = NSTextAlignmentCenter;
            _phoneLabel.centerX = _nameLabel.centerX;
            [self addSubview:_phoneLabel];
        }
    }
    return self;
}

- (void)setAccount:(GGAccount *)account{
    if (_account != account) {
        _account = account;
        
        [_faceImageView setImageWithURL:[NSURL URLWithString:_account.icon] placeholder:[UIImage imageNamed:@"user_header_default"]];
        
        _nameLabel.text = _account.realName;
        
        if (_account.mobile && _account.mobile.length > 0) {
            _phoneLabel.text=  _account.mobile;
        }else{
            _phoneLabel.text= @"";
        }
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
