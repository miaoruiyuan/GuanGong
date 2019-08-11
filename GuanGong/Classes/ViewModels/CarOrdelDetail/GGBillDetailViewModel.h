//
//  GGBillDetailViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGViewModel.h"
#import "GGBillInfo.h"
@interface GGBillDetailViewModel : GGViewModel

@property(nonatomic,strong,readonly)RACCommand *detailDataCommand;

@property(nonatomic,strong)GGBillInfo *billInfo;

@end
