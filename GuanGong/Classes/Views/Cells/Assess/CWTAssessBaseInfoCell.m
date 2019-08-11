//
//  CWTAssessBaseInfoCell.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/5/3.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTAssessBaseInfoCell.h"

NSString *const kCellIdentifierAssessBaseInfo = @"kCWTAssessBaseInfoCell";
@implementation CWTAssessBaseInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}


- (void)setupView{
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.right.equalTo(self.mas_right).offset(-12);
    }];
    
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(.6);
    }];
    
    
    NSArray *titles = @[@"所在地",@"首次上牌",@"行驶里程",@"排放标准"];
    
    __block UIView *line = nil;
    __block UIView *lastView = nil;
    [titles enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        OtherInfoView *view = [[OtherInfoView alloc] init];
        view.titleLabel.text = obj;
        view.tag = 15+idx;
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line.mas_bottom).offset(1);
            
            make.height.mas_equalTo(60);
            if (line) {
                make.left.equalTo(line.mas_right);
            }else{
                make.left.equalTo(self.mas_left);
            }
            
            if (lastView) {
                make.bottom.equalTo(lastView.mas_bottom);
            }else{
               self.bottomConstraint = make.bottom.equalTo(self.contentView.mas_bottom);
            }
            
            make.width.mas_equalTo((kScreenWidth - 3)/4);
            
            if (idx == 0) {
                self.lastInfoView = view;
            }
        }];
        
        UIView *vLine = [[UIView alloc] init];
        vLine.backgroundColor = [UIColor colorWithHexString:@"eaedef"];
        [self.contentView addSubview:vLine];
        [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_right);
            make.size.mas_equalTo(CGSizeMake(1, 15));
            make.centerY.equalTo(view.mas_centerY);
        }];
        
        line = vLine;
        lastView = view;
        
        
    }];
    

}

- (void)setResult:(CWTAssessResult *)result{
    _result = result;
    
    self.titleLabel.text = _result.title_l;
    
    OtherInfoView *areaView = [self.contentView viewWithTag:15];
    areaView.valueLabel.text = _result.city_name;
    
    OtherInfoView *regView = [self.contentView viewWithTag:16];
    regView.valueLabel.text = _result.first_reg_date;
    
    OtherInfoView *mileageView = [self.contentView viewWithTag:17];
    mileageView.valueLabel.text = [NSString stringWithFormat:@"%@万公里",_result.mileage];
    
    OtherInfoView *emissionsView = [self.contentView viewWithTag:18];
    
    if (_result.emissions_name.length == 0) {
        emissionsView.valueLabel.text = @"--";
    }else{
        emissionsView.valueLabel.text = _result.emissions_name;
        
    }
    
}

- (void)configItemWithObj:(CWTAssess *)obj{
    
    self.titleLabel.text = obj.title_l;
    
    OtherInfoView *areaView = [self.contentView viewWithTag:15];
    areaView.valueLabel.text = obj.city_name;
    
    OtherInfoView *regView = [self.contentView viewWithTag:16];
    regView.valueLabel.text = obj.first_reg_date;
    
    OtherInfoView *mileageView = [self.contentView viewWithTag:17];
    mileageView.valueLabel.text = [NSString stringWithFormat:@"%@万公里",obj.mileage];
    
    OtherInfoView *emissionsView = [self.contentView viewWithTag:18];
    if (obj.emissions_name.length == 0) {
        emissionsView.valueLabel.text = @"--";
    }else{
        emissionsView.valueLabel.text = obj.emissions_name;
    
    }
    
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"444444"];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _titleLabel.numberOfLines = 0;
        _titleLabel.preferredMaxLayoutWidth = kScreenWidth- 24;
    }
    return _titleLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"eaedef"];
    }
    return _line;
}

@end


@implementation OtherInfoView

- (id)init{
    if (self = [super init]) {
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self addSubview:self.valueLabel];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY).offset(-5);
        make.height.mas_equalTo(15);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_centerY).offset(4);
        make.height.mas_equalTo(12);
    }];
}



- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _valueLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _valueLabel;
}

@end
