//
//  GGInputAddressCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGInputAddressCell.h"
#import <IQKeyboardManager/IQTextView.h>

@interface GGInputAddressCell ()

@property(nonatomic,strong)IQTextView *remarkView;

@end

NSString *const kCellIdentifierInputAddress = @"kGGInputAddressCell";
@implementation GGInputAddressCell

- (void)setupView{
    [super setupView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.remarkView];
    [self.remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(12, 10, 10, 10));
    }];
    
    
}

- (void)configItem:(GGFormItem *)item{
    
    self.remarkView.text = item.obj;
}


- (IQTextView *)remarkView{
    if (!_remarkView) {
        _remarkView = [[IQTextView alloc] init];
        _remarkView.placeholder = @"填写详细地址";
        _remarkView.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
        _remarkView.textColor = textNormalColor;
        [_remarkView.rac_textSignal subscribeNext:^(id x) {
            if (self.valueChangedBlock) {
                self.valueChangedBlock(x);
            }
        }];
    }
    return _remarkView;
}



@end
