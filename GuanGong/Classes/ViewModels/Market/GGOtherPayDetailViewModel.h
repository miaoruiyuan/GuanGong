//
//  GGOtherPayDetailViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/8/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGViewModel.h"
#import "GGOtherPayDetail.h"

@interface GGOtherPayDetailViewModel : GGViewModel

@property(nonatomic,strong,readonly)RACCommand *applyDetailCommand;
//拒绝/取消
@property(nonatomic,strong,readonly)RACCommand *cancelApplyCommand;
@property(nonatomic,strong,readonly)RACCommand *agreeApplyCommand;

@property(nonatomic,strong)GGOtherPayDetail *otherPayDetail;




@end
