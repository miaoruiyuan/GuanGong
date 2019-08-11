//
//  GGMarketViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/9/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"

@interface GGMarketViewModel : GGTableViewModel

@property(nonatomic,strong,readonly)RACCommand *updateCommand;

- (void)setVBankDidClicked;

@end
