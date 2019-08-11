//
//  AssessHistoryViewModel.h
//  bluebook
//
//  Created by three on 2017/5/11.
//  Copyright © 2017年 iautos_miaoruiyuan. All rights reserved.
//

#import "GGTableViewModel.h"
#import "CWTAssess.h"
#import "CWTAssessResult.h"

@interface AssessHistoryViewModel : GGTableViewModel

@property(nonatomic,strong,readonly)RACCommand *historyCommand;

@property(nonatomic,strong,readonly)RACCommand *assessCommand;

@property(nonatomic,strong)CWTAssess *assess;
@property(nonatomic,strong)CWTAssessResult *assessResult;

@end
