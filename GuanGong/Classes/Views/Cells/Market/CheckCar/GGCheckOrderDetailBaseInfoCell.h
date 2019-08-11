//
//  GGCheckOrderDetailBaseInfoCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/9/12.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCheckOrderList.h"

UIKIT_EXTERN NSString * const kCellIdentifierCheckOrderDetailBaseInfo;

@interface GGCheckOrderDetailBaseInfoCell : UITableViewCell

@property(nonatomic,strong)GGCheckOrderList *orderDetail;

@property(nonatomic,strong)UIButton *reportButton;

@end
