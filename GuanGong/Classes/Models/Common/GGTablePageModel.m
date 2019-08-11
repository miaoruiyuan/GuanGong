//
//  GGTablePageModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/12.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGTablePageModel.h"

@implementation GGTablePageModel

- (BOOL)showLoadMoreView
{
   NSUInteger totalCount =  (self.pageNo.integerValue - 1) * self.pageSize.integerValue + self.currentPageSize;
    if (totalCount < [self.totalRecord integerValue]) {
        return YES;
    }
    return NO;
}

@end
