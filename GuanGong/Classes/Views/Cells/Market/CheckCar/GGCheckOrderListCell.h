//
//  GGCheckOrderListCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/9/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCheckOrderList.h"

UIKIT_EXTERN NSString *const kCellIdentifierCheckOrder;

@interface GGCheckOrderListCell : UITableViewCell

@property(nonatomic,strong)GGCheckOrderList *orderList;


@end
