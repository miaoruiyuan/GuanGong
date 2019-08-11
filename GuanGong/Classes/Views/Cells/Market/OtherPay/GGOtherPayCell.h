//
//  GGOtherPayCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/8/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGOtherPayList.h"

UIKIT_EXTERN NSString * const kCellIdentifierOtherPay;
@interface GGOtherPayCell : UITableViewCell

@property(nonatomic,strong)GGOtherPayList *otherPayList;

@property(nonatomic,assign)BOOL isMineApply;

@end
