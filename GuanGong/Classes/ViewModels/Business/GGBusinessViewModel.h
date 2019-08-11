//
//  GGBusinessViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGBusinessItem.h"
#import "GGBusinessHome.h"

@interface GGBusinessViewModel : GGTableViewModel

@property (nonatomic,assign)BOOL isOpen;

@property (nonatomic,strong)GGBusinessHome *homeData;
@end
