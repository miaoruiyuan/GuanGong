//
//  CWTLimitResultViewController.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/1/4.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTLimitResultViewController.h"

@interface CWTLimitResultViewController ()

@property(nonatomic,strong)CWTLimitCity *city;
@property(nonatomic,strong)UILabel *cityNameLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIButton *connectButton;

@end

@implementation CWTLimitResultViewController

- (id)initWithObject:(CWTLimitCity *)city{
    if (self = [super init]) {
        self.city = city;
    }
    return self;
}

- (void)setupView{
    self.navigationItem.title = @"查询结果";
    self.edgesForExtendedLayout = UIRectEdgeNone;

    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"discharge_bg"]];
    bgView.frame = CGRectMake(0, 0, kScreenWidth, 150);
    [self.view addSubview:bgView];
    
    if (!_cityNameLabel) {
        _cityNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 22)];
        _cityNameLabel.center = bgView.center;
        _cityNameLabel.font = [UIFont boldSystemFontOfSize:20];
        _cityNameLabel.textAlignment = NSTextAlignmentCenter;
        _cityNameLabel.textColor = [UIColor whiteColor];
        [bgView addSubview:_cityNameLabel];
    }
    
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = kScreenWidth-24.0;
        _contentLabel.textColor =  [UIColor colorWithHexString:@"5d5d5d"];
        _contentLabel.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(12.0);
            make.top.equalTo(bgView.mas_bottom).offset(20.0);
            make.right.equalTo(self.view.mas_right).with.offset(-12.0);
            make.height.mas_greaterThanOrEqualTo(22.0);
        }];
    }
    
    
    _cityNameLabel.text = [NSString stringWithFormat:@"%@ - %@",_city.province,_city.city];
    _contentLabel.text = _city.content ? _city.content : @"暂无";

    
    if (!_connectButton) {
        _connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _connectButton.frame = CGRectMake(40.0, kScreenHeight-180.0, kScreenWidth-80.0, 40.0);
        _connectButton.backgroundColor = [UIColor whiteColor];
        _connectButton.titleLabel.font =  [UIFont systemFontOfSize:15.0];
        _connectButton.layer.masksToBounds = YES;
        _connectButton.layer.cornerRadius = 3.0;
        _connectButton.layer.borderWidth = 1.0;
        _connectButton.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
        [_connectButton setTitleColor:[UIColor colorWithHexString:@"5d5d5d"] forState:UIControlStateNormal];
        [_connectButton setTitle:@"详细了解可致电: 400-822-0321" forState:UIControlStateNormal];
        [self.view addSubview:_connectButton];
        
        [_connectButton bk_addEventHandler:^(id sender) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-822-0321"]];
            
        } forControlEvents:UIControlEventTouchUpInside];
    }

}

- (void)bindViewModel{
    
}

@end
