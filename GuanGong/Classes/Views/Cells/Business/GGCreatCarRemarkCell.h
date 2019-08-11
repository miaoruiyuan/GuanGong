//
//  GGCreatCarRemarkCell.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFormBaseCell.h"

UIKIT_EXTERN NSString *const kCellIdentifierCreateCarRemark;
@interface GGCreatCarRemarkCell : GGFormBaseCell

@property(nonatomic,strong)GGFormItem *item;

@property (nonatomic,copy)void(^editEndBlock)(GGFormItem *item);

@end
