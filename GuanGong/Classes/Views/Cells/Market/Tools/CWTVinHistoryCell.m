//
//  CWTVinHistoryCell.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/21.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTVinHistoryCell.h"

@interface CWTVinHistoryCell ()

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *vinLabel;
@property(nonatomic,strong)UILabel *dateLabel;

@property(nonatomic,strong)UILabel *statusLabel;

@end

NSString *const kCellIdentifierVinHistoryCell = @"kCWTVinHistoryCell";

@implementation CWTVinHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(20);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        }];
        
        [self.contentView addSubview:self.vinLabel];
        [self.vinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
            make.height.mas_equalTo(20);
        }];
        
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.vinLabel);
            make.top.equalTo(self.vinLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(16);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        }];
        
        [self.contentView addSubview:self.statusLabel];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.titleLabel);
            make.centerY.height.equalTo(self.dateLabel);
        }];
    }
    return self;
}

- (void)setHistory:(CWTVinHistory *)history{
    _history = history;
    
    self.titleLabel.text = _history.title;
    self.vinLabel.text = [NSString stringWithFormat:@"VIN: %@",_history.vin];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"car_history_time_icon"];
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    [myString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",_history.createTime]]];
    
    self.dateLabel.attributedText = myString;
}

- (void)setMaintainHistory:(CWTMaintainHistory *)maintainHistory{
    _maintainHistory = maintainHistory;
    
    self.titleLabel.text = _maintainHistory.title;
    self.vinLabel.text = [NSString stringWithFormat:@"VIN: %@",_maintainHistory.vin];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"car_history_time_icon"];
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    [myString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",_maintainHistory.createTime]]];
    
    self.dateLabel.attributedText = myString;
    
    self.statusLabel.hidden = NO;
    
    NSString *status = nil;
    switch (_maintainHistory.reportStatus) {
        case 1:{
            status = @"生成中";
        }
            break;
            
        case 2:{
            status = @"暂无记录";
        }
            break;
            
        case 3:{
            status = @"暂无记录";
        }
            break;
            
        case 4:{
            status = @"已完成";
        }
            break;
            
        case 5:{
            status = @"暂无记录";
        }
            break;
            
        default:
            break;
    }

    self.statusLabel.text = status;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _titleLabel.numberOfLines = 0;
        _titleLabel.preferredMaxLayoutWidth = kScreenWidth-30;
    }
    return _titleLabel;
}

- (UILabel *)vinLabel{
    if (!_vinLabel) {
        _vinLabel = [[UILabel alloc] init];
        _vinLabel.textColor = [UIColor blackColor];
        _vinLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    }
    return _vinLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _dateLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
    }
    return _dateLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _statusLabel.font = [UIFont systemFontOfSize:13];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.hidden  = YES;
    }
    return _statusLabel;
}

@end
