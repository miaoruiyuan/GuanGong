//
//  GGOrderListModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGOrderList.h"

typedef NS_ENUM(NSInteger ,OrderListType) {
    
    OrderListTypeGoods = 1,
    OrderListTypePayment = 2,
};


@interface GGOrderListViewModel : GGTableViewModel

@property(nonatomic,assign)OrderListType type;

@property(nonatomic,copy)NSString *transStatus;

//订单号
@property(nonatomic,copy)NSString *orderNo;

//买家确认收货
@property(nonatomic,strong,readonly)RACCommand *confirmGoods;

@end
