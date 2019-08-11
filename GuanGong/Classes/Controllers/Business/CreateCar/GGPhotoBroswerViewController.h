//
//  GGPhotoBroswerViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBaseViewController.h"

@interface GGPhotoBroswerViewController : GGBaseViewController

/**
 第几张图片
 */
@property(nonatomic,assign)NSInteger index;

/**
 图片数组
 */
@property(nonatomic,strong)NSArray *items;

@end
