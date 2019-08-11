//
//  GGHelpQuestionTypesCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/24.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGHelpQuestionTypesCell.h"
#import "GGHelpQuestionTypeModel.h"

@interface GGHelpQuestionTypesCell()
{
    
}

@property (nonatomic,copy)void(^btnClickedBlock)(NSInteger index);

@end

NSString *const kGGHelpQuestionTypesCellID = @"GGHelpQuestionTypesCell";

static NSInteger Type_Btn_Base_Tag = 50;

@implementation GGHelpQuestionTypesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)typeSelectedBlock:(void(^)(NSInteger index))block
{
    self.btnClickedBlock = block;
}

- (void)showWithTypeArray:(NSArray *)typeArray
{
    [self.contentView removeAllSubviews];
    [self.contentView addSubview:[self createLabel]];
    CGFloat beginX = 12;
    CGFloat beginY = 45;
    NSInteger index = 0;
    for (GGHelpQuestionTypeModel *typeModel in typeArray) {
        UIButton *button = [self createBtn];
        button.tag = Type_Btn_Base_Tag + index;
        index++;
        [button setTitle:typeModel.typeName forState:UIControlStateNormal];
        [button sizeToFit];
        CGFloat btnWidth = button.width + 30;
        if (btnWidth + beginX > kScreenWidth) {
            beginY += 45;
            beginX = 12;
        }
        
        button.frame = CGRectMake(beginX, beginY, btnWidth , 30);
        beginX = beginX + btnWidth + 10;
        
        [self.contentView addSubview:button];
    }
}

+ (CGFloat)getCellHight:(NSArray *)typeArray
{
    CGSize infoSize = CGSizeMake(MAXFLOAT, 30);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    
    CGFloat beginX = 12;
    CGFloat beginY = 45;
    
    for (GGHelpQuestionTypeModel *typeModel in typeArray) {
        
        CGRect infoRect = [typeModel.typeName
                           boundingRectWithSize:infoSize
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:dic context:nil];
        
        CGFloat btnWidth = ceilf(infoRect.size.width) + 30;
        
        if (btnWidth + beginX > kScreenWidth) {
            beginY += 45;
            beginX = 12;
        }
        beginX = beginX + btnWidth + 10 ;
    }
    
    return beginY + 45;
}


- (void)typeBtnClicked:(UIButton *)sender
{
    if (sender.isSelected) {
        return;
    }
    
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *typeBtn = (UIButton *)view;
            if (typeBtn.isSelected) {
                [typeBtn setSelected:NO];
                [self setBtnLayer:typeBtn];
                break;
            }
        }
    }
    
    [sender setSelected:YES];
    [self setBtnLayer:sender];
    
    if (self.btnClickedBlock) {
        self.btnClickedBlock(sender.tag - Type_Btn_Base_Tag);
    }
}

#pragma mark - init view

- (UILabel *)createLabel{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 80, 16)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"反馈类型";
    return titleLabel;
}

- (UIButton *)createBtn
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor colorWithHexString:@"737373"] forState:UIControlStateNormal];
    [button setTitleColor:themeColor forState:UIControlStateSelected];
    [button setTitleColor:themeColor forState:UIControlStateHighlighted];

    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.borderWidth = 0.5f;
    button.layer.cornerRadius = 15;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [UIColor colorWithHexString:@"e7e7e7"].CGColor;
    [button addTarget:self action:@selector(typeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)setBtnLayer:(UIButton *)button
{
    if (button.isSelected) {
        button.layer.borderColor = themeColor.CGColor;

    }else{
        button.layer.borderColor = [UIColor colorWithHexString:@"e7e7e7"].CGColor;
    }
}

@end
