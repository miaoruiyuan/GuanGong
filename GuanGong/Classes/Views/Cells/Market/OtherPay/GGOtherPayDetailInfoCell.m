
//
//  GGOtherPayDetailInfoCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOtherPayDetailInfoCell.h"
#import "FDStackView.h"
#import "TTTAttributedLabel.h"

@interface GGOtherPayDetailInfoCell ()

@property(nonatomic,strong)FDStackView *stackView;
@property(nonatomic,strong)NSMutableArray *titleLabels;



@end

NSString * const kCellIdentifierOtherPayDetailInfo = @"kGGOtherPayDetailInfoCell";
@implementation GGOtherPayDetailInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
       
    
    }
    return self;
}

- (void)setPayDetail:(GGOtherPayDetail *)payDetail{
    if (_payDetail != payDetail) {
        _payDetail = payDetail;
    

        NSArray *titles = @[@"交易类型:",@"付款方式:",self.isMineApply ? @"代付人:" :@"申请人:",@"备注:"];
       
        
        NSArray *values = @[self.isMineApply ? @"担保支付" : @"代付-担保支付",
                            @"朋友代付",
                            self.isMineApply ? _payDetail.payer.realName : _payDetail.buyer.realName,
                            _payDetail.remark ? _payDetail.remark : @"无"];
        
        
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
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(12, kLeftPadding, 12, kLeftPadding));
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
