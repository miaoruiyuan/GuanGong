//
//  GGSetPasswordViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGViewModel.h"

@interface GGSetPasswordViewModel : GGViewModel

@property(nonatomic,copy)NSString *iCode;

@property(nonatomic,copy)NSString *password1;
@property(nonatomic,copy)NSString *password2;

@property(nonatomic,strong,readonly)RACSignal *enabelSignal;
@property(nonatomic,strong,readonly)RACCommand *setPayPasswordCommand;

@end
