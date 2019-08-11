
//
//  GGDetailBottomView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/23.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGDetailBottomView.h"
#import "FDStackView.h"

@interface GGDetailBottomView ()

@property(nonatomic,strong)FDStackView *stackView;

@property(nonatomic,strong)NSMutableArray *buttons;


@end


@implementation GGDetailBottomView


- (id)initWithButtonTitles:(NSArray *)titles buttonAction:(void (^)(UIButton *sender, NSInteger index))buttonAction{
    if (self = [super init]) {
     
        self.buttons = [NSMutableArray arrayWithCapacity:titles.count];
        
        for (int i = 0 ; i < titles.count; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"e5e5e5"]] forState:UIControlStateHighlighted];
            button.layer.masksToBounds  = YES;
            button.layer.cornerRadius = 2.2;
            button.layer.borderWidth = .8;
            
            
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
            
                if (buttonAction) {
                    buttonAction(x,i);
                }
            }];
            
            
            if (i == 0) {
                button.layer.borderColor = textNormalColor.CGColor;
                [button setTitleColor:textNormalColor forState:UIControlStateNormal];
                
            }else{
                button.layer.borderColor = themeColor.CGColor;
                [button setTitleColor:themeColor forState:UIControlStateNormal];

            }
        
            [self.buttons addObject:button];
        }
        
        [self addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 10, 5, 10));
        }];

        
    }
    return self;
}



+ (id)initWithButtonTitles:(NSArray *)titles buttonAction:(void (^)(UIButton *sender, NSInteger index))buttonAction{
    return [[self alloc] initWithButtonTitles:titles buttonAction:buttonAction];
}



- (FDStackView *)stackView{
    if (!_stackView) {
        _stackView = [[FDStackView alloc] initWithArrangedSubviews:self.buttons];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.spacing = 10;
    }
    return _stackView;
}



@end
