//
//  GGTextFileldCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/3.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFormBaseCell.h"

UIKIT_EXTERN NSString * const kCellIdentifierTextField;

@interface GGTextFileldCell : GGFormBaseCell

@property(nonatomic,strong)UITextField *textField;

@property(nonatomic,copy) NSString *placeHolderText;

- (void)showTitle:(NSString *)title AndPlaceholder:(NSString *)placeholder;

@end
