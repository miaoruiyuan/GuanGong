//
//  GGRefundViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGOrderDetails.h"
#import "GGCarOrderDetail.h"
#import "GGImageItem.h"


@interface GGRefundViewModel : GGTableViewModel

@property(nonatomic,strong)NSNumber *tranAmount;
@property(nonatomic,strong)NSNumber *returnType;
@property(nonatomic,strong)NSArray *photos;
@property(nonatomic,copy)NSString *refundRemark;

@property(nonatomic,copy)NSString *returnPrice;
@property(nonatomic,copy)NSString *returnFinalPrice;

//可退款金额
@property(nonatomic,copy)NSString *allowReturnPrice;
@property(nonatomic,copy)NSString *allowReturnFinalPrice;


//担保支付
@property(nonatomic,strong)GGOrderDetails *orderDetail;
//车订单详情
@property(nonatomic,strong)GGCarOrderDetail *carOrderDetail;


@property(nonatomic,strong,readonly)RACSignal *enableSubmit;
@property(nonatomic,strong,readonly)RACCommand *submitCommand;
//修改申请
@property(nonatomic,strong,readonly)RACCommand *reviseCommand;

@end
