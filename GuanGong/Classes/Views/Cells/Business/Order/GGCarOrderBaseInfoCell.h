//
//  GGCarOrderBaseInfoCell.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCarOrderDetail.h"
#import "GGNewCarDetailModel.h"

UIKIT_EXTERN NSString * const kCellIdentifierCarOrderBaseInfo;

@interface GGCarOrderBaseInfoCell : UITableViewCell

@property(nonatomic,strong)GGCarOrderDetail *orderDetail;

@property(nonatomic,strong)GGCar *car;

- (void)updateUIWithNewCarModel:(GGNewCarDetailModel *)carDetailModel;

- (void)updateUIWithOrderModel:(GGCarOrderDetail *)orderDetail andCarInfoClicked:(void(^)(GGCarOrderDetail *))block;


@end
