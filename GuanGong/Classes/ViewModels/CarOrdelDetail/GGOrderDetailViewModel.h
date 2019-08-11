//
//  GGOrderDetailViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/8/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGViewModel.h"
#import "GGOrderDetails.h"

@interface GGOrderDetailViewModel : GGViewModel

@property(nonatomic,copy)NSString *orderNo;

@property(nonatomic,strong)GGOrderDetails *orderDetail;

//详情数据
@property(nonatomic,strong,readonly)RACCommand *detailDataCommand;

//确认收货
@property(nonatomic,strong,readonly)RACCommand *confirmGoodsCommand;


@property(nonatomic,strong,readonly)RACCommand *sellerConfirmGoodsCommand;


@end
