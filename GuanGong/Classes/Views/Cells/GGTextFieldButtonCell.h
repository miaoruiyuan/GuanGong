//
//  GGTextFieldButtonCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/3.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFormBaseCell.h"

UIKIT_EXTERN NSString * const kCellIdentifierTextFieldButton;

@interface GGTextFieldButtonCell : GGFormBaseCell

@property(nonatomic,strong)UIButton *sendbutton;

@property(nonatomic,strong)UITextField *textField;

@end
