//
//  GGOrderInfoCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGOrderDetails.h"

UIKIT_EXTERN NSString * const kCellIdentifierOrderInfo;

@interface GGOrderInfoCell : UITableViewCell

@property(nonatomic,strong)GGOrderDetails *orderDetails;


@end
