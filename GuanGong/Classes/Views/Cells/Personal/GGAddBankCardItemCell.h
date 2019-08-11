//
//  GGAddBankCardItemCell.h
//  GuanGong
//
//  Created by CodingTom on 2017/3/2.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGFormBaseCell.h"
#import "GGFormItem.h"

UIKIT_EXTERN NSString * const kGGAddBankCardItemCellID;

@interface GGAddBankCardItemCell : GGFormBaseCell

@property (nonatomic,strong)UITextField *inputTextField;

- (void)configItem:(GGFormItem *)item;

- (void)configItemShowRight:(GGFormItem *)item;

@end
