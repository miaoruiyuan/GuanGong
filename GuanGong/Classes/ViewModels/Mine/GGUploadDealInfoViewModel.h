//
//  GGUploadDealInfoViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/9.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"

@interface GGUploadDealInfoViewModel : GGTableViewModel

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,strong)NSArray *photos;
@property(nonatomic,strong)NSNumber *gooodsId;

//退款/退货, 1同意 ,0拒绝
@property(nonatomic,assign)BOOL isAgree;

@property(nonatomic,copy)NSString *password;



@property(nonatomic,strong,readonly)RACSignal *enableSubmit;
@property(nonatomic,strong,readonly)RACCommand *submitCommand;


@property(nonatomic,strong,readonly)RACSignal *enableRefuseSubmit;
//拒绝退款
@property(nonatomic,strong,readonly)RACCommand *submitRefuseCommand;



@end
