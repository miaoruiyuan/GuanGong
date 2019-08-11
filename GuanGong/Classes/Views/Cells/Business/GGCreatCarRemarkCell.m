//
//  GGCreatCarRemarkCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCreatCarRemarkCell.h"
#import <IQKeyboardManager/IQTextView.h>

@interface GGCreatCarRemarkCell ()<UITextViewDelegate>

@property(nonatomic,strong)IQTextView *remarkView;

@end

NSString *const kCellIdentifierCreateCarRemark = @"kGGCreatCarRemarkCell";
@implementation GGCreatCarRemarkCell

- (void)setupView{
    [super setupView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.remarkView];
    [self.remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(12, 12, 12, 12));
    }];
    

}

- (void)configItem:(GGFormItem *)item{
    self.remarkView.text = item.obj;
}


- (IQTextView *)remarkView{
    if (!_remarkView) {
        _remarkView = [[IQTextView alloc] init];
        _remarkView.placeholder = @"描述一下车况信息";
        _remarkView.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _remarkView.textColor = textLightColor;
        _remarkView.delegate = self;
    }
    return _remarkView;
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    self.item.obj = textView.text;
    if (self.editEndBlock) {
        self.editEndBlock(self.item);
    }
}

@end
