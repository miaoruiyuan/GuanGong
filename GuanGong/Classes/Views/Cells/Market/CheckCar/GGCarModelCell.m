//
//  GGCarModelCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarModelCell.h"

@interface GGCarModelCell ()

@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *modelLabel;

@end

NSString *const kCellIdentifierCreateCarModel = @"kGGCarModelCell";

@implementation GGCarModelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right).offset(-12);
            make.height.mas_equalTo(16);
        }];
        
        [self.contentView addSubview:self.modelLabel];
        [self.modelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(16);
            make.top.equalTo(self.contentView.mas_top).offset(18);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-18);
            make.right.equalTo(self.priceLabel.mas_left).offset(-4);
        }];
    }
    return self;
}

- (void)setModel:(GGModelList *)model{
    if (_model != model) {
        _model = model;
        
        self.priceLabel.text = [NSString stringWithFormat:@"%@万",_model.n_price];
        
        NSString *modelName = nil;
        if (_model.is_turbo && _model.is_turbo == 1) {
            
            if (_model.emissions_name) {
                modelName = [NSString stringWithFormat:@"%@T %@ %@%@(%@)",_model.displacement,_model.transmission_type_name,_model.sub_name,_model.model_name,_model.emissions_name];
            }else{
                modelName = [NSString stringWithFormat:@"%@T %@ %@%@",_model.displacement,_model.transmission_type_name,_model.sub_name,_model.model_name];
            }
            
        }else{
            
            if (_model.emissions_name) {
                modelName = [NSString stringWithFormat:@"%@L %@%@%@(%@)",_model.displacement,_model.transmission_type_name,_model.sub_name,_model.model_name,_model.emissions_name];
            }else{
                modelName = [NSString stringWithFormat:@"%@L %@%@%@",_model.displacement,_model.transmission_type_name,_model.sub_name,_model.model_name];
            }
        }
        self.modelLabel.text = modelName;
    }
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.textColor = themeColor;
        _priceLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (UILabel *)modelLabel{
    if (!_modelLabel) {
        _modelLabel = [[UILabel alloc] init];
        _modelLabel.textColor = textNormalColor;
        _modelLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
        _modelLabel.numberOfLines = 0;
        _modelLabel.preferredMaxLayoutWidth = kScreenWidth - 95;
    }
    return _modelLabel;
}



@end
