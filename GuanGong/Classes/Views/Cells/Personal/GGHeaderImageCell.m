//
//  GGHeaderImageCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/5/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGHeaderImageCell.h"
#import "GGTapImageView.h"

@interface GGHeaderImageCell ()
@property (strong, nonatomic)GGTapImageView *faceView;


@end

NSString *const kCellIdentifierHeaderImage = @"kGGHeaderImageCell";

@implementation GGHeaderImageCell

-(void)setupView{
    [super setupView];
    [self.contentView addSubview:self.faceView];
    [self.faceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowView.mas_left).offset(-4);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
}

- (GGTapImageView *)faceView{
    if (!_faceView) {
        _faceView = [[GGTapImageView alloc]init];
        _faceView.layer.masksToBounds = YES;
        _faceView.layer.cornerRadius = 4.f;
    }
    return _faceView;
}


- (void)configItem:(GGFormItem *)item{
    [super configItem:item];
    
    self.arrowView.hidden = NO;
    [self.faceView setImageWithURL:[NSURL URLWithString:item.obj]
                          placeholder:[UIImage imageNamed:@"user_header_default"]
                              options:YYWebImageOptionAllowInvalidSSLCertificates | YYWebImageOptionIgnoreDiskCache
                             progress:nil
                            transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                                return [image imageByResizeToSize:CGSizeMake(240, 240) contentMode:UIViewContentModeScaleAspectFill];
                            }
                           completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//                               if (error) {
//                                   [MBProgressHUD showError:@"连接错误"];
//                               }
                               
                           }];

}



@end
