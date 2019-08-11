//
//  GGVehicleWarrantyItemCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/2/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGVehicleWarrantyItemCell.h"

NSString *const kGGVehicleWarrantyItemCell = @"GGVehicleWarrantyItemCell";

@interface GGVehicleWarrantyItemCell ()
{

}

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *contentLabel;


@end

@implementation GGVehicleWarrantyItemCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [ super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(10);
            make.width.mas_equalTo(70);
        }];
        
        [self.contentView addSubview:self.contentLabel];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(85);
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateUIWithModel:(GGFormItem *)model
{
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.propertyName;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"222222"] ;
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor colorWithHexString:@"222222"] ;
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return _contentLabel;
}

@end
