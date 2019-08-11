//
//  GGSearchFriendView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/5.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGSearchFriendView.h"

@interface GGSearchFriendView ()

@property(nonatomic,strong)UIImageView *searchView;
@property(nonatomic,strong)UILabel *holderLabel;


@end

@implementation GGSearchFriendView


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.searchView];
        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).with.offset(22);
            make.width.height.mas_equalTo(22);
        }];
        
        
        [self addSubview:self.holderLabel];
        [self.holderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchView.mas_right).with.offset(26);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(60);
        }];
        
        
     
    }
    return self;
}

- (UIImageView *)searchView{
    if (!_searchView) {
        _searchView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchFriend"]];
    }
    return _searchView;
}

- (UILabel *)holderLabel{
    
    if (!_holderLabel) {
        _holderLabel = [[UILabel alloc]init];
        _holderLabel.text = @"手机号";
        _holderLabel.textColor = textLightColor;
        _holderLabel.font = [UIFont systemFontOfSize:15];
    }
    return _holderLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
