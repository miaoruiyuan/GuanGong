//
//  GGCarOrderPriceCell.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCar.h"
#import "GGCarOrderDetail.h"

UIKIT_EXTERN NSString * const kCellIdentifierCarOrderPrice;

@interface GGCarOrderPriceCell : UITableViewCell

@property(nonatomic,strong)GGCar *car;

@property(nonatomic,strong)GGCarOrderDetail *orderDetail;

- (void)showUIWithReservePrice:(NSString *)reservePrice finalPrice:(NSString *)finalPrice;

@end
