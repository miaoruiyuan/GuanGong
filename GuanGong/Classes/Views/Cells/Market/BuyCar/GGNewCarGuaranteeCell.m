//
//  GGNewCarGuaranteeCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/10.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGNewCarGuaranteeCell.h"

NSString *const kGGNewCarGuaranteeCellID = @"GGNewCarGuaranteeCell";

@interface GGNewCarGuaranteeCell()
{
    
}

@property (nonatomic,strong)UIImageView *left1IconImageView;
@property (nonatomic,strong)UIImageView *left2IconImageView;

@property (nonatomic,strong)UILabel *title1Label;
@property (nonatomic,strong)UILabel *title2Label;

@end

@implementation GGNewCarGuaranteeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showWithTagArray:(NSArray<NSString*> *)tagArray
{
    [self.contentView removeAllSubviews];
    CGFloat beginX = 12;
    CGFloat beginY = 8;
    for (NSString *tagTitle in tagArray) {
        UIButton *button = [self createBtn];
        [button setTitle:[NSString stringWithFormat:@" %@",tagTitle] forState:UIControlStateNormal];
        [button sizeToFit];
        
        if (button.width + beginX + 20 > kScreenWidth) {
            beginY += 28;
            beginX = 12;
        }
        
        button.frame = CGRectMake(beginX, beginY, button.width, 20);
        beginX = beginX + button.width + 8;
        
        [self.contentView addSubview:button];
    }
}

#pragma mark - initView

- (UIButton *)createBtn
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"buy_new_car_wuliu_icon"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    return button;
}

+ (CGFloat)getCellHight:(NSArray<NSString*> *)tagArray
{
    CGSize infoSize = CGSizeMake(MAXFLOAT, 20);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};

    CGFloat beginX = 12;
    CGFloat beginY = 8;
    
    for (NSString *tagTitle in tagArray) {
        
        CGRect infoRect = [[NSString stringWithFormat:@" %@",tagTitle]
                           boundingRectWithSize:infoSize
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:dic context:nil];
        
        CGFloat titleWidth = ceilf(infoRect.size.width) + 13;

        if (titleWidth + beginX + 20 > kScreenWidth) {
            beginY += 28;
            beginX = 12;
        }
        beginX = beginX + titleWidth + 8;
    }
    
    return beginY + 32;
}

@end
