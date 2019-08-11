//
//  GGCompanyCodeCell.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/7.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGFormBaseCell.h"

UIKIT_EXTERN NSString *const kGGCompanyCodeCellID;


@interface GGCompanyCodeCell : GGFormBaseCell

@property (nonatomic,strong)UITextField *inputTextField;
@property (nonatomic,strong)UIButton *titleBtn;

- (void)configItem:(GGFormItem *)item;

@end
