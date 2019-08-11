//
//  GGSystemMessageCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/6/14.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGSystemMessageCell.h"

NSString *const kGGSystemMessageCellID = @"GGSystemMessageCell";

@interface GGSystemMessageCell()
{
    
}

@property (nonatomic,strong)UIImageView *titleImageView;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UILabel *desLabel;
@property (nonatomic,strong)UIImageView *rightImageView;

@end

@implementation GGSystemMessageCell

@synthesize titleLabel = _titleLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupView
{
    
}

- (void)updateUIWithModel:(NSObject *)model
{
    
}

@end
