//
//  GGCarOrderExpressCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarOrderExpressCell.h"

@interface GGCarOrderExpressCell ()
@property(nonatomic,strong)UILabel *expressTitleLabel;
@property(nonatomic,strong)UILabel *expressValueLabel;

@end

NSString * const kCellIdentifierCarOrderExpress = @"kGGCarOrderExpressCell";

@implementation GGCarOrderExpressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [self.contentView addSubview:self.expressTitleLabel];
        [self.expressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(14);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(16);
        }];
        
        [self.contentView addSubview:self.expressValueLabel];
        [self.expressValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-14);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(16);
        }];
    }
    return self;
}


- (void)showTitle:(NSString *)title content:(NSString *)content
{
    self.expressTitleLabel.text = title;
    self.expressValueLabel.text = content;
}

- (UILabel *)expressTitleLabel{
    if (!_expressTitleLabel) {
        _expressTitleLabel = [[UILabel alloc] init];
        _expressTitleLabel.text = @"配送方式";
        _expressTitleLabel.textColor = [UIColor blackColor];
        _expressTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _expressTitleLabel;
}

- (UILabel *)expressValueLabel{
    if (!_expressValueLabel) {
        _expressValueLabel = [[UILabel alloc] init];
        _expressValueLabel.text = @"自取";
        _expressValueLabel.textColor = [UIColor blackColor];
        _expressValueLabel.font = [UIFont systemFontOfSize:14];
        _expressValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _expressValueLabel;
}

@end
