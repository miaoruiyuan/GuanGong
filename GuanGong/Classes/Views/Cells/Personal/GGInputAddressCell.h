//
//  GGInputAddressCell.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFormBaseCell.h"

UIKIT_EXTERN NSString *const kCellIdentifierInputAddress;
@interface GGInputAddressCell : GGFormBaseCell

@property (nonatomic,copy)void(^valueChangedBlock)(NSString *text);

@end
