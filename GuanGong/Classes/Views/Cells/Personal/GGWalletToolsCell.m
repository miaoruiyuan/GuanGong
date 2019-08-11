//
//  GGWalletToolsCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGWalletToolsCell.h"
#import "UIButton+Common.h"
#import "FDStackView.h"

@interface GGWalletToolsCell ()
@property(nonatomic,strong)FDStackView *stackView;

@end


NSString *const kCellIdentifierWalletTools  = @"kGGWalletToolsCell";

@implementation GGWalletToolsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        
        NSArray *titles = @[@"充值",@"提现",@"转账",@"银行卡"];
        NSArray *images = @[@"wallet_chongzhi",@"wallet_tixian",@"wallet_zhuanzhang",@"wallet_card"];
        
    
        for (int i = 0 ; i < titles.count; i ++ ) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"353535"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular]];
            [button centerImageAndTitle:8];
            button.tag = i + 29;
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
                
                if ([self.delegate respondsToSelector:@selector(selectWalletToolBarButtonIndex:)]) {
                    [self.delegate selectWalletToolBarButtonIndex:x.tag];
                }
                
            }];
            
            [self.stackView addArrangedSubview:button];
            
        }
        
        
    }
    return self;
}



- (FDStackView *)stackView{
    if (!_stackView) {
        _stackView = [[FDStackView alloc] init];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.alignment = UIStackViewAlignmentFill;
    }
    return _stackView;
}


@end
