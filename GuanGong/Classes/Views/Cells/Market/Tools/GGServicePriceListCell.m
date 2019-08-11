//
//  GGServicePriceListCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/12.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGServicePriceListCell.h"

NSString *const kGGServicePriceListCellID = @"GGServicePriceListCell";

@interface GGServicePriceListCell()
{
}

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *priceLabel;

@property (nonatomic,strong)UILabel *originalPriceLabel;

@property (nonatomic,strong)UILabel *desLabel;


@end

@implementation GGServicePriceListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.contentView).offset(-14);
    }];
    
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.contentView).offset(-14);
    }];
    
    [self.contentView addSubview:self.originalPriceLabel];
    [self.originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(5);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.contentView).offset(-14);
    }];
    
    [self.contentView addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self.contentView).offset(16);
    }];
    
    [self.contentView addSubview:self.buyBtn];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateUIWithModel:(GGSearvicePriceListModel *)model
{
    self.titleLabel.text = [NSString stringWithFormat:@"查询%@次",[model.num stringValue]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[model.price stringValue]];
    
    if (model.originalPrice) {
        NSString *textStr = [NSString stringWithFormat:@"￥%@ ",[model.originalPrice stringValue]];
        self.originalPriceLabel.text = textStr;
        self.originalPriceLabel.hidden = NO;
    }else{
        self.originalPriceLabel.hidden = YES;
    }
 
//    //中划线
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr];
//        [attribtStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, textStr.length)];
    // 赋值
    if (model.des && model.des.length > 0){
        self.desLabel.text = model.des;
        self.desLabel.hidden = NO;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(-14);
        }];
        [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(-14);
        }];
        [self.originalPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(-14);
        }];
    }else{
        self.desLabel.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
        }];
        [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
        }];
        [self.originalPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
        }];
    }
}


#pragma mark - init view 

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = textNormalColor;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont boldSystemFontOfSize:15];
        _priceLabel.textColor = themeColor;
    }
    return _priceLabel;
}

- (UILabel *)originalPriceLabel
{
    if (!_originalPriceLabel) {
        _originalPriceLabel = [[UILabel alloc] init];
        _originalPriceLabel.font = [UIFont systemFontOfSize:15];
        _originalPriceLabel.textColor = textLightColor;
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = textLightColor;
        [_originalPriceLabel addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_originalPriceLabel);
            make.centerY.equalTo(_originalPriceLabel);
            make.height.mas_equalTo(1);
        }];
        
    }
    return _originalPriceLabel;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:13];
        _desLabel.textColor = textLightColor;
    }
    return _desLabel;
}

- (UIButton *)buyBtn
{
    if (!_buyBtn){
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setTitleColor:themeColor forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        _buyBtn.layer.masksToBounds = YES;
        _buyBtn.layer.cornerRadius = 3;
        _buyBtn.layer.borderColor = themeColor.CGColor;
        _buyBtn.layer.borderWidth = 1;
        [_buyBtn setTitle:@"购买" forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return _buyBtn;
}

@end
