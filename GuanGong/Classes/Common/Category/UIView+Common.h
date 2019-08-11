//
//  UIView+Common.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/24.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Common)


//获取该视图的控制器
- (UIViewController*) viewController;

//删除当前视图内的所有子视图
- (void) removeChildViews;

//删除tableview底部多余横线
- (void)setExtraCellLineHidden: (UITableView *)tableView;

@end
