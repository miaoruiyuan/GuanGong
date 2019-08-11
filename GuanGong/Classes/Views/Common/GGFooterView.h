//
//  GGFooterView.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGFooterView : UIView

- (instancetype)initWithFrame:(CGRect)frame andFootButtonTitle:(NSString *)title;

@property(nonatomic,strong)UIButton *footerButton;

@end
