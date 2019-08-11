//
//  GGCheckCardIDViewModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/3/21.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"

@interface GGCheckCardIDViewModel : GGTableViewModel

@property(nonatomic,strong)NSString *cardID;

@property(nonatomic,strong,readonly)RACCommand *submitCardInfoCommand;

@property(nonatomic,strong,readonly)RACSignal *submitBtnEnableSinal;

@end
