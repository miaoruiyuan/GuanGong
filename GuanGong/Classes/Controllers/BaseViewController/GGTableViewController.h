//
//  GGTableViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBaseViewController.h"

@interface GGTableViewController : GGBaseViewController<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,assign)UITableViewStyle style;
@property(nonatomic,strong)UITableView *baseTableView;

/**
 *  是否显示空的占位数据
 */
@property(nonatomic,assign)BOOL emptyDataDisplay;
/**
 *  空数据title
 */
@property(nonatomic,copy)NSString *emptyDataTitle;
/**
 *  空数据详情
 */
@property(nonatomic,copy)NSString *emptyDataMessage;


/**
 *  启用下拉刷新
 */
@property(nonatomic,assign)BOOL enabledRefreshHeader;
/**
 *  启用上拉加载
 */
@property(nonatomic,assign)BOOL enabledRefreshFooter;
/**
 *  开始Header刷新
 */
-(void)beginHeaderRefreshing;
/**
 *  停止Header刷新
 */
- (void)endRefreshHeader;
/**
 *  刷新HeaderAction(子类重载)
 */
- (void)refreshHeaderAction;
/**
 *  开始Footer加载
 */
-(void)beginFooterRefreshing;
/**
 *  停止Footer加载
 */
-(void)endRefreshFooter;
/**
 *  刷新FooterAction(子类重载)
 */
- (void)refreshFooterAction;
/**
 *  提示没有更多
 */
- (void)footerEndNoMoreData;

@end
