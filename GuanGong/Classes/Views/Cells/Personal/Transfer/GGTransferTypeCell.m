//
//  GGTransferTypeCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTransferTypeCell.h"

@interface GGTransferTypeCell ()

@property(nonatomic,strong)UILabel *titleLabel;

@end

NSString * const kCellIdentifierTransferType = @"kGGTransferTypeCell";

@implementation GGTransferTypeCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPadding, 7, 100, 30)];
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.font = [UIFont systemFontOfSize:16];
            _titleLabel.textColor = [UIColor blackColor];
            _titleLabel.text = @"支付类型";
            [self.contentView addSubview:_titleLabel];
        }
        
        NSArray *items = @[@"订金",@"全款"];
        
        if (!_segment) {
            _segment = [[UISegmentedControl alloc]initWithItems:items];
            _segment.selectedSegmentIndex =  0;
            _segment.tintColor = themeColor;
            self.accessoryView = _segment;
        }
    }
    return self;
}

+ (CGFloat)cellHeight
{
    return 44.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
