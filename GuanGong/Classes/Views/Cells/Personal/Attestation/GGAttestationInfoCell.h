//
//  GGAttestationInfoCell.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/5.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGFormBaseCell.h"

UIKIT_EXTERN NSString *const kGGAttestationInfoCellID;

@interface GGAttestationInfoCell : GGFormBaseCell

@property (nonatomic,strong)UITextField *inputTextField;

- (void)configItem:(GGFormItem *)item;

@end
