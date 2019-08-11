
//
//  GGCapitalClearInfoCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCapitalClearInfoCell.h"
#import "MJPhotoBrowser.h"
@interface GGCapitalClearInfoCell ()

@property(nonatomic,strong)UILabel *amountLabel;
@property(nonatomic,strong)UILabel *bankLabel;
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *picLabel;



@end

NSString * const kCellIdentifierClearInfo = @"kGGCapitalClearInfoCell";
@implementation GGCapitalClearInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.amountLabel];
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(12);
            make.left.equalTo(self.contentView.mas_left).offset(kLeftPadding);
            make.height.mas_equalTo(16);
        }];
        
        [self.contentView addSubview:self.bankLabel];
        [self.bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.equalTo(self.amountLabel);
            make.top.equalTo(self.amountLabel.mas_bottom).offset(10);
        }];
        
        [self.contentView addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.equalTo(self.bankLabel);
            make.top.equalTo(self.bankLabel.mas_bottom).offset(10);
        }];
        
        
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.equalTo(self.numberLabel);
            make.top.equalTo(self.numberLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-12).with.priorityLow();
        }];
        
    }
    return self;
}


- (void)setClearDetail:(GGCapitalClearList *)clearDetail{
    if (_clearDetail != clearDetail) {
        _clearDetail = clearDetail;
        
        
        self.amountLabel.text = [NSString stringWithFormat:@"充值金额:  %@",_clearDetail.amount];
        self.bankLabel.text = [NSString stringWithFormat:@"充值银行:  %@",_clearDetail.bankName];
        self.numberLabel.text = [NSString stringWithFormat:@"银行卡号:  %@",_clearDetail.accountNo];
        self.dateLabel.text = [NSString stringWithFormat:@"提交时间:  %@", _clearDetail.createTimeStr];
        
        NSMutableArray *pics = [NSMutableArray arrayWithObjects:_clearDetail.pic1,_clearDetail.pic2,_clearDetail.pic3, nil];
        
        
        if (pics.count) {
            
            [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.height.equalTo(self.numberLabel);
                make.top.equalTo(self.numberLabel.mas_bottom).offset(10);
            }];
            
            [self.contentView addSubview:self.picLabel];
            [self.picLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.height.equalTo(self.dateLabel);
                make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
            }];
            
            for (int i = 0; i < pics.count; i ++) {
                GGTapImageView *imageView = [[GGTapImageView alloc]init];
                imageView.tag = i + 10;
                [self.contentView addSubview:imageView];
                [imageView setImageWithUrl:[NSURL URLWithString:pics[i]] placeholderImage:[UIImage imageNamed:@"car_detail_image_failed"] tapBlock:^(GGTapImageView *obj) {
                    
                    
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
                
                CGFloat imageWidth = (kScreenWidth -76.0) / 4.0;
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.picLabel.mas_right).with.offset(10 + i*(imageWidth + 12));
                    make.top.equalTo(self.picLabel.mas_top);
                    make.width.mas_equalTo(imageWidth);
                    make.height.mas_equalTo(imageWidth);
                    make.bottom.equalTo(self.contentView.mas_bottom).offset(-12).priorityLow();
                    
                }];
                
            }
        }

        
        
    }
}


- (UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc]init];
        _amountLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        _amountLabel.textColor = textNormalColor;
    }
    
    return _amountLabel;
}

- (UILabel *)bankLabel{
    if (!_bankLabel) {
        _bankLabel = [[UILabel alloc]init];
        _bankLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        _bankLabel.textColor = textNormalColor;
    }
    
    return _bankLabel;
}



- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        _numberLabel.textColor = textNormalColor;
    }
    
    return _numberLabel;
}



- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        _dateLabel.textColor = textNormalColor;
    }
    
    return _dateLabel;
}

- (UILabel *)picLabel{
    if (!_picLabel) {
        _picLabel = [[UILabel alloc]init];
        _picLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        _picLabel.textColor = textNormalColor;
        _picLabel.text = @"充值凭证:";
    }
    
    return _picLabel;
}





@end


