//
//  GGVehicleWarrantyCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/2/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGVehicleWarrantyCell.h"

NSString *const kGGVehicleWarrantyCellID = @"GGVehicleWarrantyCell";

@interface GGVehicleWarrantyCell()
{
    
}

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,strong) UIView *lineView;


@end


@implementation GGVehicleWarrantyCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [ super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(25);
        }];
        
        [self.contentView addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(52);
        }];
        
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(90);
            make.height.mas_equalTo(0.5);
        }];
        [self.contentView addSubview:self.submitBtn];
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(43);
            make.bottom.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(90);
        }];
    }
    return self;
}

- (void)updateUIWithStatus:(BOOL)checked
{
    self.titleLabel.text = @"车辆质检";
    self.desLabel.text = @"319项全方位极致检测，让你放心购买";
    self.submitBtn.enabled = !checked;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"222222"];
    }
    return  _titleLabel;
}

- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:13];
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return  _desLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = sectionColor;
    }
    
    return _lineView;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"立即申请" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor colorWithHexString:@"508cee"] forState:UIControlStateNormal];
        
        [_submitBtn setTitle:@"已申请过质检" forState:UIControlStateDisabled];
        [_submitBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
        
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _submitBtn;
}

@end
