//
//  GGMaskViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/10.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMaskViewController.h"
#import "ImageMaskView.h"
#import "GGImageItem.h"
@interface GGMaskViewController ()

@property(nonatomic,strong)ImageMaskView *maskView;

@end

@implementation GGMaskViewController

- (void)bindViewModel{
    if (self.value) {
        GGImageItem *item = self.value;
        self.maskView.image = item.thumbnailImage;
        [self.maskView beginInteraction];
    }
}

- (void)setupView{
    [self.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}



- (ImageMaskView *)maskView{
    if (!_maskView) {
        _maskView = [[ImageMaskView alloc] init];
        _maskView.radius = 10;
        _maskView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _maskView;
}
@end
