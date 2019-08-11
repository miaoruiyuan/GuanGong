//
//  GGFormItem.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFormItem.h"

@implementation GGFormItem

//
//- (GGPersonalInput *)pageContent{
//    if (!_pageContent) {
//        _pageContent = [[GGPersonalInput alloc]init];
//    }
//    return _pageContent;
//}


-(BOOL)isPicker{
    return self.pageType == GGPageTypePickerDate;
}


@end

