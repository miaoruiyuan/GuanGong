//
//  GGCarBrandCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarBrandCell.h"

@interface GGCarBrandCell ()

@property(nonatomic,strong)UIImageView *logoView;
@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)MASConstraint *labelLeftConstraint;

@end

NSString *const kCellIdentifierCreateCarBrand = @"kJGBCarBrandCell";
@implementation GGCarBrandCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.logoView];
        [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            self.labelLeftConstraint =  make.left.equalTo(self.logoView.mas_right).offset(12);
            make.centerY.equalTo(self.logoView);
            make.height.mas_equalTo(20);
        }];
        
        
    }
    return self;
}



- (void)setBrand:(GGCarBrand *)brand{
    if (_brand != brand) {
        _brand = brand;
        
        [self.logoView setImageWithURL:[NSURL URLWithString:_brand.logo]
                              placeholder:[UIImage imageNamed:@"placeHolder"]
                                  options:YYWebImageOptionProgressiveBlur
                               completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                   
                               }];
        
        self.nameLabel.text = _brand.name;
        
        //卸载重建
        [self.labelLeftConstraint uninstall];
        if ([_brand.name isEqualToString:@"不限品牌"]) {
            [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
               self.labelLeftConstraint =  make.left.equalTo(self.logoView.mas_left);
            }];
        }else{
            [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                self.labelLeftConstraint =  make.left.equalTo(self.logoView.mas_right).offset(12);
            }];
        }
    
    }
}

- (UIImageView *)logoView{
    if (!_logoView) {
        _logoView = [[UIImageView alloc] init];
        _logoView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = textNormalColor;
        _nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
    }
    return _nameLabel;
}


@end
