//
//  GGMyFriendsViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/5.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGFriendsList.h"

@interface GGMyFriendsViewModel : GGTableViewModel

@property(nonatomic,strong,readonly)RACCommand *friendNewCommand;
//申请代付
@property(nonatomic,strong,readonly)RACCommand *applyPayCommand;

@property(nonatomic,strong)NSArray *indexTitles;

//申请代付
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,strong)NSNumber *applyAmount;
@property(nonatomic,strong)NSNumber *salerId;
@property(nonatomic,strong)NSNumber *goodsStatusId;
@property(nonatomic,copy)NSString *remark;




@end
