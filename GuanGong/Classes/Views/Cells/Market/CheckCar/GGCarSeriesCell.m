
//
//  GGCarSeriesCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarSeriesCell.h"

@interface GGCarSeriesCell ()

@property(nonatomic,strong)UILabel *seriesLabel;

@end

NSString *const kCellIdentifierCreateCarSeries = @"kJGBCarSeriesCell";
@implementation GGCarSeriesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [self.contentView addSubview:self.seriesLabel];
        [self.seriesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(20);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(20);
        }];
        
        
    }
    return self;
}


- (void)setSer:(GGSeries *)ser{
    if (_ser != ser) {
        _ser = ser;
        self.seriesLabel.text = _ser.name_show;
        
    }
    
}



- (UILabel *)seriesLabel{
    if (!_seriesLabel) {
        _seriesLabel = [[UILabel alloc] init];
        _seriesLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
        _seriesLabel.textColor = textNormalColor;
    }
    return _seriesLabel;
}



@end
