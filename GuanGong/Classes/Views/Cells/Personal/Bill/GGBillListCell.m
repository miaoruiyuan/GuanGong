//
//  GGBillListCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBillListCell.h"
#import "GGTapImageView.h"
#import "NSDate+Common.h"
#import "NSString+Common.h"

@interface GGBillListCell ()

@property(nonatomic,strong)UILabel *dayLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *detailLabel;
@property(nonatomic,strong)UILabel *statusLabel;
@property(nonatomic,strong)GGTapImageView *faceView;

@end

NSString * const kCellIdentifierBillListCell = @"kGGBillListCell";

@implementation GGBillListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    
        if (!_dayLabel) {
            _dayLabel = [[UILabel alloc]init];
            _dayLabel.textColor = textLightColor;
            _dayLabel.textAlignment = NSTextAlignmentCenter;
            _dayLabel.font = [UIFont systemFontOfSize:16];
            [self.contentView addSubview:_dayLabel];
        }
        
        if (!_timeLabel) {
            _timeLabel = [[UILabel alloc]init];
            _timeLabel.textColor = textLightColor;
            _timeLabel.textAlignment = NSTextAlignmentCenter;
            _timeLabel.font = [UIFont systemFontOfSize:10];
            [self.contentView addSubview:_timeLabel];
        }

        
        
        if (!_faceView) {
            _faceView = [[GGTapImageView alloc]init];
            [self.contentView addSubview:_faceView];
        }

        if (!_priceLabel) {
            _priceLabel = [[UILabel alloc]init];
            _priceLabel.font = [UIFont systemFontOfSize:18];
            [self.contentView addSubview:_priceLabel];
        }

        
        
        if (!_detailLabel) {
            _detailLabel = [[UILabel alloc]init];
            _detailLabel.textColor = textLightColor;
            _detailLabel.font = [UIFont systemFontOfSize:12.8];
            [self.contentView addSubview:_detailLabel];
        }

        if (!_statusLabel) {
            _statusLabel = [[UILabel alloc]init];
            _statusLabel.textColor = textLightColor;
            _statusLabel.font = [UIFont systemFontOfSize:13.2];
            [self.contentView addSubview:_statusLabel];
        }

        
        
        
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(kLeftPadding);
            make.top.equalTo(self.contentView.mas_top).with.offset(14);
        }];
        
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dayLabel);
            make.top.equalTo(_dayLabel.mas_bottom).offset(8);
        }];
        
        [_faceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(74);
            make.width.height.mas_equalTo(38);
            make.centerY.equalTo(self.contentView);
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_faceView.mas_right).offset(kLeftPadding);
            make.top.equalTo(_dayLabel.mas_top);
        }];
        
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_priceLabel.mas_left);
            make.bottom.equalTo(_timeLabel.mas_bottom);
        }];
        
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_priceLabel);
            make.right.equalTo(self.contentView.mas_right).with.offset(-20);
        }];
        
    
    }
    return self;
}


- (void)setItem:(BillItem *)item{
    if (_item != item) {
        _item = item;
        
        
        [self.faceView setImageWithURL:[NSURL URLWithString:_item.dealerIcon] placeholder:[UIImage imageNamed:@"user_header_default"] options:YYWebImageOptionAllowInvalidSSLCertificates progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
            return [image imageByResizeToSize:CGSizeMake(180, 180) contentMode:UIViewContentModeScaleAspectFill];
        } completion:nil];
        
        
        
        if ([_item.tranFlag isEqualToNumber:@1]) {
            self.priceLabel.text = [NSString stringWithFormat:@"-%@",[NSString positiveFormat:_item.tranAmount]];
            self.priceLabel.textColor = [UIColor colorWithHexString:@"#FB8638"];
            self.detailLabel.text = [NSString stringWithFormat:@"%@给%@",_item.operName,_item.dealerRealName];
        }else{
            self.priceLabel.text = [NSString stringWithFormat:@"+%@",[NSString positiveFormat:_item.tranAmount]];
            self.priceLabel.textColor = [UIColor colorWithHexString:@"#3bbd79"];
            self.detailLabel.text = [NSString stringWithFormat:@"收到%@%@",_item.dealerRealName,_item.operName];
        }
        
        self.statusLabel.text = _item.dealTypeName;
        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [NSDate  dateWithTimeIntervalSince1970:[_item.tranDate doubleValue]/1000];
        self.dayLabel.text = [date stringDisplay_MMdd];
        self.timeLabel.text = [date stringDisplay_HHmm];

    }
}




@end
