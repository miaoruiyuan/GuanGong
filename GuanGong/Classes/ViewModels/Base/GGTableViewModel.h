//
//  GGTableViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGViewModel.h"
#import "GGFormItem.h"

@interface GGTableViewModel : GGViewModel

@property (nonatomic,assign)BOOL canLoadMore, willLoadMore, isLoading;

@property(nonatomic,assign)NSInteger pageIndex;

@property(nonatomic,retain)NSNumber *totalCount,*treatedCount,*untreatedCount;

//复制的dic
@property(nonatomic,copy)NSDictionary *rawDic;
//首先加载数据库的内容
@property(nonatomic,strong)RACCommand *loadDBdata;
//拉取数据
@property(nonatomic,strong)RACCommand *loadData;
//下一页数据
@property(nonatomic,strong)RACCommand *loadNext;
//上传数据
@property(nonatomic,strong)RACCommand *updateData;
//刷新
@property(nonatomic,strong)RACCommand *reloadData;
//数据源
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSArray *footerTips;
@property(nonatomic,strong)NSArray *headerTips;

-(id)itemForIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)itemCountAtSection:(NSInteger)section;
-(NSInteger)sectionCount;

-(id)footerTipAtSection:(NSInteger)section;
-(id)headerTipsAtSection:(NSInteger)section;


@end
