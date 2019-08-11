
//
//  GGOtherPayDetailDateCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOtherPayDetailDateCell.h"
#import "FDStackView.h"
#import "TTTAttributedLabel.h"

@interface GGOtherPayDetailDateCell ()
@property(nonatomic,strong)FDStackView *stackView;
@property(nonatomic,strong)NSMutableArray *titleLabels;


@end

NSString * const kCellIdentifierOtherPayDetailDate = @"kGGOtherPayDetailDateCell";
@implementation GGOtherPayDetailDateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        
    }
    return self;
}


- (void)setPayDetail:(GGOtherPayDetail *)payDetail{
    if (_payDetail != payDetail) {
        _payDetail = payDetail;
        
        NSArray *titles = nil;
        NSArray *values = nil;
        if (_payDetail.subOrderNo) {
            titles  = @[@"创建时间:",@"订单编号:"];
            values = @[_payDetail.createTimeStr,_payDetail.subOrderNo];
        }else{
            titles = @[@"创建时间:",];
            values = @[_payDetail.createTimeStr];
        }
       
        
        for (int i = 0 ; i < titles.count; i ++) {
            TTTAttributedLabel *label = [TTTAttributedLabel new];
            label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
            label.textColor = textLightColor;
            
            [label setText:[NSString stringWithFormat:@"%@  %@",titles[i],values[i]] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                
                NSRange markRange = [[mutableAttributedString string] rangeOfString:values[i] options:NSCaseInsensitiveSearch];
                [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName: textNormalColor,NSFontAttributeName : [UIFont systemFontOfSize:14 weight:UIFontWeightRegular]} range:markRange];
                
                return mutableAttributedString;
            }];
            
            [self.titleLabels addObject:label];

        }
        
        
        [self.contentView addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(20);
            make.top.equalTo(self.contentView.mas_top).with.offset(12);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
        }];
        
    }
}


- (FDStackView *)stackView{
    if (!_stackView) {
        _stackView = [[FDStackView alloc] initWithArrangedSubviews:self.titleLabels];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.spacing = 10;
        
    }
    return _stackView;
}


- (NSMutableArray *)titleLabels{
    if (!_titleLabels) {
        _titleLabels  = [[NSMutableArray alloc] init];
    }
    return _titleLabels;
}


@end
