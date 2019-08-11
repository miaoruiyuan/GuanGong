//
//  GGPersonalBaseCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFormBaseCell.h"

@implementation GGFormBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(78);
    }];
    
    [self.contentView addSubview:self.arrowView];
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
}


-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:15.6 weight:UIFontWeightRegular];
        _titleLabel.textColor = textNormalColor;
        [_titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}

- (UIImageView *)arrowView{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right_small"] highlightedImage:[UIImage imageNamed:@"arrow_right_small"]];
        
    }
    return _arrowView;
}

-(void)configItem:(GGFormItem *)item{

    if (item.canEdit) {
        self.arrowView.hidden = NO;
    }else{
        self.arrowView.hidden = YES;
    }
    self.titleLabel.text = item.title;
}



@end
