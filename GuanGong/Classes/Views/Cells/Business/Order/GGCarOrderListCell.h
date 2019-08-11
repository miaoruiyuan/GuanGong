//
//  GGCarOrderListCell.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCarOrderDetail.h"

UIKIT_EXTERN NSString * const kCellIdentifierCarOrderList;

@interface GGCarOrderListCell : UITableViewCell

@property(nonatomic,strong)GGCarOrderDetail *orderDetail;

@property(nonatomic, copy)void(^functionButtonBlock)(NSString *title);

@end
