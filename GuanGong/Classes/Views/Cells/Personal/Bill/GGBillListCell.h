//
//  GGBillListCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGBillList.h"


UIKIT_EXTERN NSString * const  kCellIdentifierBillListCell;

@interface GGBillListCell : UITableViewCell

@property(nonatomic,strong)BillItem *item;

@end
