//
//  GGFriendBillListCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/3/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGFriendBillListCell.h"
@interface GGFriendBillListCell()
{
}

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *moneyLabel;

@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *statusLabel;

@end

@implementation GGFriendBillListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(12);
        }];
        
        [self.contentView addSubview:self.moneyLabel];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView).offset(12);
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.contentView).offset(-12);
        }];
        
        [self.contentView addSubview:self.statusLabel];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView).offset(-12);
        }];
    }
    return self;
}

- (void)updateUIWithModel:(BillItem *)model
{
    if (model.remark && model.remark.length > 0) {
        self.titleLabel.text = model.remark;
    }else{
        self.titleLabel.text = model.operName;
    }
    
    if ([model.tranFlag isEqualToNumber:@1]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"-%@",[NSString positiveFormat:model.tranAmount]];
    }else{
        self.moneyLabel.text = [NSString stringWithFormat:@"+%@",[NSString positiveFormat:model.tranAmount]];
    }
  
    self.statusLabel.text = model.dealTypeName;

    NSDate *date = [NSDate  dateWithTimeIntervalSince1970:[model.tranDate doubleValue]/1000];
    self.timeLabel.text = [date stringDisplay_MM_dd];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - init View

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = textNormalColor;
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.font = [UIFont systemFontOfSize:15];
        _moneyLabel.textColor = textNormalColor;
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = textLightColor;
    }
    return _timeLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.font = [UIFont systemFontOfSize:13];
        _statusLabel.textColor = textLightColor;
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

@end
