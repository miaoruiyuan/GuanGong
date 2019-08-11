//
//  GGCarOrderViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGCarOrderDetail.h"

typedef NS_ENUM(NSInteger,CarsOrderListType) {
    CarsOrderListTypeAll = 0,
    CarsOrderListTypeDFK,
    CarsOrderListTypeDSH,
    CarsOrderListTypeYWC,
    CarsOrderListTypeTKZ
};

@interface GGCarOrderViewModel : GGTableViewModel

@property(nonatomic,assign)CarsOrderListType orderListType;

@property(nonatomic,assign)BOOL isSeller;

@property(nonatomic,strong)GGCarOrderDetail *orderDetail;

@property(nonatomic,strong,readonly)RACCommand *orderDetailCommand;

@property(nonatomic,strong,readonly)RACCommand *confirmGoodsCommand;

//卖家收到退货
@property(nonatomic,strong,readonly)RACCommand *sellerConfirmGoodsCommand;


@end
