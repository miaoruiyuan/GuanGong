//
//  GGSwichCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/24.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGSwichCell.h"

@interface GGSwichCell ()

@end

NSString * const kCellIdentifierSwich = @"kGGSwichCell";
@implementation GGSwichCell


- (void)setupView{
    [super setupView];
    self.accessoryView = self.swich;
    
//    
//    [[self.swich rac_signalForControlEvents:UIControlEventValueChanged]subscribeNext:^(UISwitch *x) {
//        
//        if (self.swichBlock) {
//            self.swichBlock(x);
//        }
//    }];
    
    
}

- (UISwitch *)swich{
    if (!_swich) {
        _swich = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    }
    return _swich;
}

@end
