//
//  GGPersonalBaseCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGFormItem.h"

@interface GGFormBaseCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *arrowView;

-(void)setupView;

-(void)configItem:(GGFormItem *)item;

@end
