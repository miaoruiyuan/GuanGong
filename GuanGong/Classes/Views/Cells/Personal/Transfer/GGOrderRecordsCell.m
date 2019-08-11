//
//  GGOrderRecordsCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/9.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOrderRecordsCell.h"

@interface GGOrderRecordsCell ()

@property(nonatomic,strong)UILabel *stateLabel;
@property(nonatomic,strong)UILabel *remarkLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *timeLabel;




@end

NSString * const kCellIdentifierOrderRecord = @"kGGOrderRecordsCell";
@implementation GGOrderRecordsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.stateLabel];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(kLeftPadding);
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.height.mas_equalTo(16);
        }];
        
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stateLabel);
            make.top.equalTo(self.stateLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        }];
        
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-20);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(14);
        }];
        
        
       
    
        
    }
    return self;
}


- (void)setOrderRecords:(GGOrderRecords *)orderRecords{
    if (_orderRecords != orderRecords) {
        _orderRecords = orderRecords;

        
        self.stateLabel.text = _orderRecords.statusName;
        if (_orderRecords.price) {
            self.priceLabel.text = [NSString stringWithFormat:@"%@元",_orderRecords.price];
        }
        
        
        self.timeLabel.text = [NSDate dateWithTimeIntreval:_orderRecords.createTime];
        
        if (_orderRecords.remark.length > 0) {
             self.remarkLabel.text = _orderRecords.remark;
            [self.contentView addSubview:self.remarkLabel];
            [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.stateLabel);
                make.top.equalTo(self.stateLabel.mas_bottom).offset(10);
            }];
            
            
            [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.remarkLabel);
                make.top.equalTo(self.remarkLabel.mas_bottom).offset(10);
                make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            }];
            
        
        }
        
       
        
        
    }
}



- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.font = [UIFont systemFontOfSize:15.6];
        _stateLabel.textColor =  textNormalColor;
    }
    return _stateLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = [UIFont systemFontOfSize:13.6 weight:UIFontWeightSemibold];
        _priceLabel.textColor = [UIColor blackColor];
        [_priceLabel sizeToFit];
    }
    return _priceLabel;
}

- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc]init];
        _remarkLabel.textColor = textLightColor;
        _remarkLabel.font = [UIFont systemFontOfSize:12.4];
    }
    return _remarkLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = textLightColor;
        _timeLabel.font = [UIFont systemFontOfSize:12.4];
    }
    return _timeLabel;
}

@end

