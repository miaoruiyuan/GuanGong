//
//  GGVehicleImagesCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/14.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGVehicleImagesCell.h"

@interface GGVehicleImagesCell ()

@property(nonatomic,strong)UIImageView *imgView;

@end

NSString *const kCellIdentifierVehicleImages = @"kGGVehicleImagesCell";

@implementation GGVehicleImagesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [ super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        [self.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 12, 5, 12));
        }];

    }
    return self;
}

- (void)setUrl:(NSString *)url{
    _url = url;
    
    [self.imgView setImageWithURL:[NSURL URLWithString:_url]
                         placeholder:[UIImage imageNamed:@"car_detail_image_failed"]
                             options:YYWebImageOptionAllowInvalidSSLCertificates | YYWebImageOptionProgressive
                          completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                              
                          }];
    
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgView;
}


@end
