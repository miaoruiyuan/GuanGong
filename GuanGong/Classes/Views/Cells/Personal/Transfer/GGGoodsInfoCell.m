//
//  GGGoodsInfoCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/9.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGGoodsInfoCell.h"
#import "MJPhotoBrowser.h"

@interface GGGoodsInfoCell ()

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *remarkLabel;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *noDataLabel;
@property(nonatomic,strong)UIImageView *noDateImageView;;

@end

NSString * const kCellIdentifierGoodsInfo = @"kGGGoodsInfoCell";
@implementation GGGoodsInfoCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).with.offset(18);
            make.height.mas_equalTo(18);
        }];
        
        [self.contentView addSubview:self.remarkLabel];
        [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(self.contentView.mas_right).with.offset(-12);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10).priority(720);
        }];
    }
    return self;
}


- (void)setGoodInfo:(GGGoodsInfo *)goodInfo
{
    if (_goodInfo != goodInfo) {
        _goodInfo = goodInfo;
    
        self.remarkLabel.text = _goodInfo.remark.length > 0 ? _goodInfo.remark : nil;
        
        if (_goodInfo.title.length > 0) {
            self.nameLabel.text = _goodInfo.title;
            [self.noDataLabel removeFromSuperview];
            [self.noDateImageView removeFromSuperview];
        }else{
            [self.contentView addSubview:self.noDateImageView];
            [self.noDateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.mas_equalTo(26);
                make.size.mas_equalTo(CGSizeMake(45, 42));
            }];
            [self.contentView addSubview:self.noDataLabel];
            [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.noDateImageView.mas_bottom).offset(10);
                make.left.right.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView).offset(-26);
            }];
        }
        
        NSMutableArray *pics = [[_goodInfo.pics componentsSeparatedByString:@","] mutableCopy];
        [pics removeLastObject];
        
        if (pics.count > 0) {
            [self setUploadImages:pics];
        }else{
            for (UIView *view in self.contentView.subviews) {
                if ([view isKindOfClass:[GGTapImageView class]]) {
                    [view removeFromSuperview];
                }
            }
        }
    }
}

- (void)setUploadImages:(NSArray *)pics
{
    [self.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView.mas_right).with.offset(-12);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    
    for (int i = 0; i < pics.count; i ++) {
        GGTapImageView *imageView = [[GGTapImageView alloc]init];
        imageView.tag = i + 10;
        [self.contentView addSubview:imageView];
        [imageView setImageWithUrl:[NSURL URLWithString:pics[i]] placeholderImage:[UIImage imageNamed:@"image_failed"] tapBlock:^(GGTapImageView *obj) {
            
            
            NSInteger row = 0;
            NSMutableArray *photoArray = [NSMutableArray array];
            MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
            for (NSString *imageURL in pics) {
                MJPhoto *photo = ({
                    MJPhoto *photo = [[MJPhoto alloc] init];
                    photo.url = [NSURL URLWithString:imageURL];
                    photo.srcImageView = obj;
                    photo;
                });
                row++;
                [photoArray addObject:photo];
            }
            photoBrowser.photos = photoArray;
            photoBrowser.currentPhotoIndex = i;
            [photoBrowser show];
            
        }];
        
        CGFloat imageWidth = (kScreenWidth -60.0) / 4.0;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(12 + i*(imageWidth + 12));
            make.top.equalTo(self.remarkLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(imageWidth);
            make.height.mas_equalTo(imageWidth);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
        }];
    }

}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = textNormalColor;
    }
    
    return _nameLabel;
}



- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc]init];
        _remarkLabel.textColor = textNormalColor;
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.font = [UIFont systemFontOfSize:15];
    }
    return _remarkLabel;
}


- (UILabel *)noDataLabel{
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        _noDataLabel.textColor = [UIColor colorWithHexString:@"#dcdcdc"];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.text = @"卖家未上传交易信息";
        _noDataLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
    }
    return _noDataLabel;
}

- (UIImageView *)noDateImageView
{
    if (!_noDateImageView) {
        _noDateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_info_noupload"]];
    }
    return _noDateImageView;
}

@end
