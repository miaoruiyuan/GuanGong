//
//  GGOrderStateCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/8/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGOrderList.h"

UIKIT_EXTERN NSString * const kCellIdentifierOrderState;

@interface GGOrderStateCell : UITableViewCell

@property(nonatomic,strong)GGOrderList *orderList;

- (void)updateUIWithModel:(GGOrderList *)orderList andReceiptTime:(NSString *)time;

@end
