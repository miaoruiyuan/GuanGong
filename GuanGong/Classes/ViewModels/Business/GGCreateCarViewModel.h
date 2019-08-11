//
//  GGCreateCarViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGCar.h"
#import "GGImageItem.h"

@interface GGCreateCarViewModel : GGTableViewModel


- (instancetype)initWithEditCar:(GGCar *)car;


@property(nonatomic,strong)GGCar *car;
@property(nonatomic,strong)RACCommand *vinCommand;
@property(nonatomic,strong)NSArray  *modelList;
@property(nonatomic,strong)RACSignal *enableReleaseSignal;

@property(nonatomic,assign,readonly)BOOL isEditCar;

/**
 上传车辆图片
 */
@property(nonatomic,strong,readonly)RACCommand *upLoadPhotosCommand;

/**
 发布
 */
@property(nonatomic,strong,readonly)RACCommand *releaseCommand;


//存放PHAsset
@property(nonatomic,strong)NSMutableArray<PHAsset*> *assetArray;

//存放CarImage
@property(nonatomic,strong)NSMutableArray<GGImageItem*> *imageItems;


- (void)addAnPHAsset:(PHAsset *)asset;

/**
 删除一张
 @param carImg carImg description
 */
- (void)deleteCarImage:(GGImageItem *)carImg;

/**
 判断填写痕迹
 @return return value description
 */
- (BOOL)checkCompare;

/**
 判断能不能发布
 @return return value description
 */
- (BOOL)canSend;

/**
 保存草稿
 */
- (void)saveSendData;

/**
 载入草稿
 */
- (void)loadSendData;

/**
 删除草稿
 */
- (void)deleteSendDataWithEndBlock:(void(^)(BOOL error))end;

@end
