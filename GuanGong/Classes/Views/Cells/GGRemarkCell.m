//
//  GGRemarkCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGRemarkCell.h"

@interface GGRemarkCell ()

@end

NSString * const kCellIdentifierRemarkCell = @"kGGRemarkCell";

@implementation GGRemarkCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.remarkTextView];
        [self.remarkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 12, 10, 12));
        }];
    }
    return self;
}

- (void)updateUIWithFeedbackModel:(GGFeedbackRequestModel *)model
{
    self.remarkTextView.placeholder = @"感谢您使用关二爷，请描述您遇到的问题或建议";
    self.remarkTextView.text = model.content;
    self.remarkTextView.textColor = textNormalColor;
}

#pragma mark - init View

- (IQTextView *)remarkTextView{
    if (!_remarkTextView) {
        _remarkTextView = [[IQTextView alloc] init];
        _remarkTextView.font = [UIFont systemFontOfSize:13.4];
        _remarkTextView.backgroundColor = [UIColor whiteColor];
        _remarkTextView.layer.masksToBounds = YES;
        _remarkTextView.layer.cornerRadius = 6;
        _remarkTextView.layer.borderColor = tableBgColor.CGColor;
        _remarkTextView.layer.borderWidth = .5;
        _remarkTextView.textColor = textLightColor;
    }
    return _remarkTextView;
}

@end
