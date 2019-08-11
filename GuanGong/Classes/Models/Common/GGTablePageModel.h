//
//  GGTablePageModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/12.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGTablePageModel : NSObject

@property (nonatomic,strong)NSNumber *pageSize;
@property (nonatomic,strong)NSNumber *pageNo;
@property (nonatomic,strong)NSNumber *totalRecord;
@property (nonatomic,strong)NSNumber *totalPage;

@property (nonatomic,assign)NSInteger currentPageSize;


- (BOOL)showLoadMoreView;

@end
