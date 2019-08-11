//
//  GGNewCarOrderBaseInfoCell.h
//  GuanGong
//
//  Created by CodingTom on 2017/7/21.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGTableViewCell.h"
#import "GGNewCarDetailModel.h"
#import "GGCarOrderDetail.h"

UIKIT_EXTERN NSString * const kGGNewCarOrderBaseInfoCellID;

@interface GGNewCarOrderBaseInfoCell : GGTableViewCell

- (void)updateUIWithNewCarModel:(GGNewCarDetailModel *)carDetailModel;

- (void)setCountChangeBlock:(void(^)(NSInteger count))block;

- (void)updateUIWithOrderModel:(GGCarOrderDetail *)orderDetail andCarInfoClicked:(void(^)(GGCarOrderDetail *))block;

@end
