//
//  GGPersonItemCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/2/21.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGPersonItemCell.h"

NSString *const kCellIdentifierPersonItem = @"GGPersonItemCell";

@interface GGPersonItemCell()
{
    
}

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *desLabel;


@property(nonatomic,strong)UIImageView *arrowView;

@end


@implementation GGPersonItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    [self.contentView addSubview:self.iconImageView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(19, 19));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(52);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(78);
    }];
    
     [self.contentView addSubview:self.desLabel];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.desLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-22);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    
    [self.contentView addSubview:self.arrowView];
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
}


- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:15.6 weight:UIFontWeightRegular];
        _titleLabel.textColor = textNormalColor;
        [_titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right_small"] highlightedImage:[UIImage imageNamed:@"arrow_right_small"]];
    }
    return _arrowView;
}

-(UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]init];
        _desLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _desLabel.textAlignment = NSTextAlignmentRight;
        _desLabel.textColor = textLightColor;
    }
    return _desLabel;
}

-(void)configItem:(GGFormItem *)item
{
    if (item.canEdit) {
        self.arrowView.hidden = NO;
    }else{
        self.arrowView.hidden = YES;
    }
    self.iconImageView.image = [UIImage imageNamed:item.propertyName];
    self.titleLabel.text = item.title;
    
    if ([item.title isEqualToString:@"客服电话"]) {
        self.desLabel.hidden = NO;
        self.desLabel.text = item.obj;
    }else{
        self.desLabel.hidden = YES;
    }
}

@end
