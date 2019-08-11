//
//  TZPhotoBrowserController.h
//  iautosCar
//
//  Created by three on 2017/1/9.
//  Copyright © 2017年 iautos_miaoruiyuan. All rights reserved.
//

#import "GGBaseViewController.h"
#import "CarScrollImageModel.h"

@protocol PhotoBrowserDelegate<NSObject>

- (void)dismissViewWithTurnToIndex:(NSInteger)index;

@end

@interface TZPhotoBrowserController : GGBaseViewController

@property (strong, nonatomic) NSMutableArray *imageArr;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (assign, nonatomic) CGRect originalRect;
@property (assign, nonatomic) id<PhotoBrowserDelegate>delegate;

@property (nonatomic, copy) NSString *titleStr;

@end
