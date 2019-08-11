//
//  GGHomeAccountView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/5/30.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGHomeAccountView.h"


@interface GGHomeAccountView ()

@property(nonatomic,strong)UILabel *totalLabel;
@property(nonatomic,strong)UILabel *balanceLabel;
@property(nonatomic,strong)UILabel *freezeLabel;

@end

@implementation GGHomeAccountView


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat hPadding = 12;
        
        if (!_totalLabel) {
            _totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(hPadding, 15, 120, 19)];
            _totalLabel.text = @"---";
            _totalLabel.font =  [UIFont systemFontOfSize:17];
            _totalLabel.textColor = [UIColor redColor];
            [self addSubview:_totalLabel];
        }
        
        if (!_balanceLabel) {
            _balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_totalLabel.right + hPadding, _totalLabel.top, frame.size.width - _totalLabel.width - hPadding * 3, _totalLabel.height)];
            _balanceLabel.textColor = [UIColor colorWithHexString:@"8d8d8d"];
            _balanceLabel.text = @"---";
            _balanceLabel.textAlignment = NSTextAlignmentCenter;
            _balanceLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:_balanceLabel];
        }
    
        
        
    }
    return self;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
