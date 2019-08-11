//
//  GGCapitalClearViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/8/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGCapitalClearList.h"

@interface GGCapitalClearViewModel : GGTableViewModel

@property(nonatomic,strong)NSArray *photos;

@property(nonatomic,copy)NSString *accountNo;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *bankName;

@property(nonatomic,strong)GGCapitalClearList *clearDetail;

@property(nonatomic,strong,readonly)RACSignal *enableSubmitSignal;

@property(nonatomic,strong,readonly)RACCommand *submitCommand;
@property(nonatomic,strong,readonly)RACCommand *detailCommand;

@end
