
//
//  GGBillDetailDateCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBillDetailDateCell.h"
#import "TTTAttributedLabel.h"
#import "FDStackView.h"

@interface GGBillDetailDateCell ()

@property(nonatomic,strong)FDStackView *stackView;
@property(nonatomic,strong)NSMutableArray *titleLabels;

@end

NSString * const  kCellIdentifierBillDetailDate = @"kGGBillDetailDateCell";
@implementation GGBillDetailDateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


//- (void)setBillList:(GGBillList *)billList{
//    if (_billList != billList) {
//        _billList = billList;
//        
//        NSArray *titles = @[@"创建时间:",@"订单编号:",@"交易号:"];
//        
//        
//        NSArray *values = @[[NSDate dateWithDateIntreval:_billList.tranDate],
//                            _billList.orderNo,
//                            _billList.payId];
//        
//        
//        for (int i = 0 ; i < titles.count; i ++) {
//            TTTAttributedLabel *label = [TTTAttributedLabel new];
//            label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
//            label.textColor = textLightColor;
//            
//            [label setText:[NSString stringWithFormat:@"%@  %@",titles[i],values[i]] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//                
//                NSRange markRange = [[mutableAttributedString string] rangeOfString:values[i] options:NSCaseInsensitiveSearch];
//                [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName: textNormalColor,NSFontAttributeName : [UIFont systemFontOfSize:14 weight:UIFontWeightRegular]} range:markRange];
//                
//                return mutableAttributedString;
//            }];
//            
//            [self.titleLabels addObject:label];
//        }
//        
//        [self.contentView addSubview:self.stackView];
//        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(12, kLeftPadding, 12, kLeftPadding));
//        }];
//        
//    }
//}

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
