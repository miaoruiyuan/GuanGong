//
//  GGAboutViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGAboutViewController.h"


@interface GGAboutViewController ()

@property(nonatomic,strong)UIImageView *logo;
@property(nonatomic,strong)UILabel *adLabel;
@property(nonatomic,strong)UILabel *versionLabel;


@end


static NSString *adText = @"        关二爷是北京阳光第一车网科技有限公司提供的一个二手车交易支付平台。该平台旨在解决二手车交易中存在的资金安全及购车效率低的问题。通过担保支付的交易方式，确保用户资金安全，同时为用户提供一种以线上交易、线下质检、送货到家为整体的全方位的快捷购车体验。我们会通过不断的尝试和改进，为用户提供越来越好的服务。";


@implementation GGAboutViewController

- (void)setupView{
    self.navigationItem.title = @"关于";
    self.view.backgroundColor = tableBgColor;
    
    [self.view addSubview:self.logo];
    [self.logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(97, 33));
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(120);
        make.centerX.equalTo(self.view);
    }];
    
    
    [self.view addSubview:self.adLabel];
    [self.adLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logo.mas_bottom).offset(30);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    
    [self.view addSubview:self.versionLabel];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-40);
        make.height.mas_equalTo(18);
    }];
    
}




- (UIImageView *)logo{
    if (!_logo) {
        _logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guanerye_logo"]];
    }
    return _logo;
}


- (UILabel *)adLabel{
    if (!_adLabel) {
        _adLabel = [[UILabel alloc] init];
        _adLabel.text = adText;
        _adLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        _adLabel.textColor = textNormalColor;
        _adLabel.numberOfLines = 0;
        [_adLabel sizeToFit];
        _adLabel.attributedText = [adText attributedStringWithLineSpace:6];
    }
    return _adLabel;
}


- (UILabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc]init];
        _versionLabel.text = [NSString stringWithFormat:@"版本: v%@",[[UIApplication sharedApplication] appVersion]];
        _versionLabel.textColor = textNormalColor;
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.font = [UIFont systemFontOfSize:14];
    }
    return _versionLabel;
}






@end
