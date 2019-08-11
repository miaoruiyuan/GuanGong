//
//  GGGoodsInfo.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/9.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGGoodsInfo : NSObject

@property(nonatomic,copy)NSString *remark;
@property(nonatomic,strong)NSNumber *goodsId;
@property(nonatomic,copy)NSString *pics;
@property(nonatomic,copy)NSString *title;

@end


/*
 goodsInfo =     {
 description = "<null>";
 id = "<null>";
 pics = "<null>";
 title = "<null>";
 };
 */