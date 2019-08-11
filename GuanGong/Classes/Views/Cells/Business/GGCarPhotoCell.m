//
//  GGCarPhotoCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/27.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarPhotoCell.h"

@interface GGCarPhotoCell ()
@property (nonatomic ,strong)UIImageView *imgView;
@property (nonatomic ,strong)UIButton *delButton;

@end

#define CCell_Width floorf((kScreenWidth - 15*2- 10*3)/4)
@implementation GGCarPhotoCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f7f9f9"];
        [self.contentView addSubview:self.imgView];
        
        [self.contentView addSubview:self.delButton];
        [self.delButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.top.left.equalTo(self.contentView).offset(-5);
        }];
    }
    return self;
}

- (void)setCarImg:(GGImageItem *)carImg{
    _carImg = carImg;
    
    if (_carImg) {
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        if (_carImg.photoUrl) {
            [self.imgView setImageWithURL:[NSURL URLWithString:_carImg.thumbnailPhotoUrl] options:YYWebImageOptionIgnorePlaceHolder];
        }else{
            RAC(self.imgView,image) = [RACObserve(self.carImg, thumbnailImage) takeUntil:self.rac_prepareForReuseSignal];
        }
        
        _delButton.hidden = NO;
        [_delButton addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(32, 32));
            make.center.equalTo(self.contentView);
        }];
        self.imgView.image = [UIImage imageNamed:@"add_photo"];
        _delButton.hidden = YES;
    }
}

- (void)deleteBtnClicked:(id)sender{
    if (_deleteCarImage) {
        _deleteCarImage(self.carImg);
    }
}


- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UIButton *)delButton{
    if (!_delButton) {
        _delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delButton setImage:[UIImage imageNamed:@"btn_delete_image"] forState:UIControlStateNormal];
        _delButton.backgroundColor = [UIColor blackColor];
        _delButton.layer.cornerRadius = 10;
        _delButton.layer.masksToBounds = YES;
    }
    return _delButton;
}

+ (CGSize)ccellSize{
    return CGSizeMake(CCell_Width, CCell_Width);
}

@end
