//
//  GGCollectionViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBaseViewController.h"

@interface GGCollectionViewController : GGBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *baseCollectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *colletionLayout;

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
 *  停止Header加载
 */
-(void)endRefreshFooter;
/**
 *  刷新FooterAction(子类重载)
 */
- (void)refreshFooterAction;


@end
