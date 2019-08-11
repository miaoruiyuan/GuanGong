//
//  GGBillListViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/15.
//  Copyright © 2016年 iautos. All rights reserved.
//


#import "GGTableViewModel.h"
#import "GGBillList.h"

@interface GGBillListViewModel : GGTableViewModel

@property(nonatomic,strong)GGBillList *billList;

@property(nonatomic,strong)NSString *otherUserId;

- (NSString *)getSectionTitle:(NSUInteger)section;

@end
