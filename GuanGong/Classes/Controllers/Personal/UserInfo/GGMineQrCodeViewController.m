//
//  GGMineQrCodeViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/14.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMineQrCodeViewController.h"

@interface GGMineQrCodeViewController ()

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *qrView;

@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UILabel *nickNameLabel;
@property(nonatomic,strong)UILabel *tipLabel;
@property(nonatomic,strong)UILabel *cityLabel;


@end

@implementation GGMineQrCodeViewController


- (void)setupView{
    self.navigationItem.title = @"我的二维码";
    self.view.backgroundColor = tableBgColor;
    
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(self.view.height * .2, 22, self.view.height * .18, 22));
    }];
    
    //二维码
    [self.bgView addSubview:self.qrView];
    [self.qrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(210);
        make.center.equalTo(self.bgView);
        
    }];
    
    //头像
    [self.bgView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.bgView).offset(20);
        make.width.height.mas_equalTo(60);
    }];
    
    //昵称
    [self.bgView addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_right).offset(8);
        make.top.equalTo(self.headView.mas_top).offset(4);
        make.height.mas_equalTo(18);
    }];
    
    //所在地
    [self.bgView addSubview:self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel);
        make.bottom.equalTo(self.headView.mas_bottom).offset(-6);
        make.height.mas_equalTo(13);
    }];
    
    //提示
    [self.bgView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).with.offset(-14);
        make.height.mas_equalTo(13);
        make.centerX.equalTo(self.bgView);
    }];
    
    
    
    [self.qrView setImageWithURL:[NSURL URLWithString:[GGLogin shareUser].user.qrCodeUri] options:YYWebImageOptionAllowInvalidSSLCertificates |YYWebImageOptionShowNetworkActivity | YYWebImageOptionProgressive | YYWebImageOptionIgnoreDiskCache];
    

}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [_bgView setLayerShadow:[UIColor lightGrayColor] offset:CGSizeMake(4, 4) radius:3.4];
    }
    return _bgView;
}


- (UIImageView *)qrView{
    if (!_qrView) {
        _qrView = [[UIImageView alloc]init];
    }
    return _qrView;
}

- (UIImageView *)headView{
    if (!_headView) {
        _headView = [[UIImageView alloc]init];
        [_headView setImageWithURL:[NSURL URLWithString:[GGLogin shareUser].user.headPic] placeholder:[UIImage imageNamed:@"user_header_default"]];
        
    }
    return _headView;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.text = @"扫一扫上面的二维码图案,加我好友";
        _tipLabel.textColor = textLightColor;
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc]init];
        NSString *userName = [GGLogin shareUser].user.realName;
        if (userName && userName.length > 0) {
            _nickNameLabel.text = userName;
        }else{
            _nickNameLabel.text = [GGLogin shareUser].user.mobile;
        }
        _nickNameLabel.font = [UIFont boldSystemFontOfSize:14.6];
        _nickNameLabel.textColor = [UIColor blackColor];
    }
    return _nickNameLabel;
}

- (UILabel *)cityLabel{
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc]init];
        _cityLabel.text = [GGLogin shareUser].user.zipCode;
        _cityLabel.font = [UIFont systemFontOfSize:12];
        _cityLabel.textColor = textLightColor;
    }
    return _cityLabel;
}





@end


/*
 YYImageCache *cache = [YYWebImageManager sharedManager].cache;
 
 cache.memoryCache.totalCost;
 cache.memoryCache.totalCount;
 cache.diskCache.totalCost;
 cache.diskCache.totalCount;
 
 // clear cache
 [cache.memoryCache removeAllObjects];
 [cache.diskCache removeAllObjects];
 
 // clear disk cache with progress
 [cache.diskCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
 // progress
 } endBlock:^(BOOL error) {
 // end
 }];
 */
