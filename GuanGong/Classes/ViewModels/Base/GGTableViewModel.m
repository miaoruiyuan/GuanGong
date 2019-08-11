//
//  GGTableViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"

@implementation GGTableViewModel

- (NSInteger)sectionCount{
    return self.dataSource.count;
}

- (NSInteger)itemCountAtSection:(NSInteger)section{
    return [self.dataSource count] ? [self.dataSource[section] count] : 0;
}

- (id)itemForIndexPath:(NSIndexPath *)indexPath{
    return self.dataSource[indexPath.section][indexPath.row];
}

- (id)footerTipAtSection:(NSInteger)section{
    return self.footerTips[section];
}
- (id)headerTipsAtSection:(NSInteger)section{
    return self.headerTips[section];
}

- (void)didSelectedItemAtIndexPath:(NSIndexPath *)indexPath{}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
