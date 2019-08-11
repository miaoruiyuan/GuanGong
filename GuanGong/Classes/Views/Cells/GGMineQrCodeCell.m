//
//  GGMineQrCodeCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/14.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMineQrCodeCell.h"


@interface GGMineQrCodeCell ()

@property(nonatomic,strong)UIImageView *qrView;


@end

NSString *const kCellIdentifierMineQrCode = @"kGGMineQrCodeCell";
@implementation GGMineQrCodeCell


- (void)setupView{
    [super setupView];
    
    [self.contentView addSubview:self.qrView];
    [self.qrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.right.equalTo(self.arrowView.mas_left).offset(-4);
        make.centerY.equalTo(self.contentView);
    }];
    
}

- (void)configItem:(GGFormItem *)item{
    [super configItem:item];
}


- (UIImageView *)qrView{
    if (!_qrView) {
        _qrView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qrCode_tip"]];
    }
    return _qrView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
