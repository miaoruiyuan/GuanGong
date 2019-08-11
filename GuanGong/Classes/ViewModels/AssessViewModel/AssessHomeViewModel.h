//
//  AssessHomeViewModel.h
//  bluebook
//
//  Created by three on 2017/5/3.
//  Copyright © 2017年 iautos_miaoruiyuan. All rights reserved.
//

#import "GGTableViewModel.h"
#import "CWTAssess.h"
#import "CWTAssessResult.h"

@interface AssessHomeViewModel : GGTableViewModel

@property(nonatomic,strong)RACCommand *locationCommand;

@property(nonatomic,strong,readonly)RACSignal *enableAssessSignal;
@property(nonatomic,strong,readonly)RACCommand *assessCommand;

@property(nonatomic,strong)CWTAssess *assessModel;
@property(nonatomic,strong)CWTAssessResult *assessResult;

@property(nonatomic,strong) NSMutableArray *historyList;

@end
