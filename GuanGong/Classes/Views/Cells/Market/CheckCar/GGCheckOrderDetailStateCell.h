//
//  GGCheckOrderDetailStateCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/9/12.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCheckOrderList.h"

UIKIT_EXTERN NSString * const kCellIdentifierCheckOrderState;
@interface GGCheckOrderDetailStateCell : UITableViewCell

@property(nonatomic,assign)CheckOrderStatus orderStatus;

@end
