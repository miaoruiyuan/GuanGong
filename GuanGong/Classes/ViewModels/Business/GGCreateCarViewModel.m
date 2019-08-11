//
//  GGCreateCarViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCreateCarViewModel.h"
#import "GGDatePicker.h"
#import "GGCarBrand.h"
#import "GGQiNiu.h"
#import "GGApiManager+QiNiu.h"

@interface GGCreateCarViewModel ()

@property(nonatomic,strong)NSArray *configArray;
@property(nonatomic,strong)GGQiNiu *qiNiu;
@property(nonatomic,strong)RACCommand *getTokenCommand;

@end

static NSString *carCacheName = @"kCarCacheName";

@implementation GGCreateCarViewModel

- (instancetype)initWithEditCar:(GGCar *)car
{
    self = [super init];
    if (self) {
        _isEditCar = YES;
        _car = [car modelCopy];
        _car.price = [NSString stringWithFormat:@"%0.2f",[_car.price floatValue] / 10000];
        [self initialize];
    }
    return self;
}

- (void)initialize{
    
    self.rawDic = [self.car modelToJSONObject];

    self.configArray = [NSArray configArrayWithResource:@"CreateCar"];
    self.dataSource = [self converWithModel:self.car];
    
    if (!self.isEditCar) {
        //载入草稿
        if ([YYCache cacheWithName:carCacheName]) {
            [self loadSendData];
        }
    }

    @weakify(self);
    //监听Vin结果
    [[RACObserve(self, modelList) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        [self.reloadData execute:nil];
    }];
    
    //编辑车辆监听
    [RACObserve(self, car) subscribeNext:^(GGCar *car) {
        @strongify(self);
        if (car) {
            _imageItems = [NSMutableArray arrayWithCapacity:car.photosList.count];
            for (int i = 0; i < car.photosList.count; i ++) {
                GGImageItem *item = [[GGImageItem alloc] init];
                item.uploadState = GGImageUploadStateSuccess;
                item.photoUrl = car.photosList[i];
                item.thumbnailPhotoUrl = car.mediumUrlList[i];
                [self.imageItems addObject:item];
            }
            [self.reloadData execute:nil];
        }
    }];
    
    //发布按钮点击enable
    _enableReleaseSignal = [RACSignal combineLatest:@[RACObserve(self,car.vin),
                                                      RACObserve(self,car.title),
                                                      RACObserve(self,car.km),
                                                      RACObserve(self,car.firstRegDate),
                                                      RACObserve(self,car.remark),
                                                      RACObserve(self,car.price),
                                                      RACObserve(self,car.reservePrice),
                                                      RACObserve(self,car.address)] reduce:^id(NSString *vin,
                                                                                               NSString *title,
                                                                                               NSString *km,
                                                                                               NSString *firstRegDate,
                                                                                               NSString *remark,
                                                                                               NSString *price,
                                                                                               NSString *reservePrice,
                                                                                               NSString *address){
                                                          return @(vin && title && km && firstRegDate && remark && price && reservePrice && address);
                                                      }];
    
    
    //上传图片
    _upLoadPhotosCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            dispatch_group_t group = dispatch_group_create();
            for (NSInteger i = 0; i < self.imageItems.count; i++) {
                dispatch_group_enter(group);
                [NSObject showStatusBarQueryStr:@"上传图片中..."];
                GGImageItem *carImage = self.imageItems[i];
                if (carImage.uploadState == GGImageUploadStateFail || carImage.uploadState == GGImageUploadStateInit) {
                    [GGApiManager uploadWithImage:carImage.imageData
                                           token:self.qiNiu.uptoken
                                             key:[self qiniuKey]
                                        progress:^(NSString *key, float percent) {
                                            DLog(@"%@\n%f",key,percent);
                                        }
                                        andBlock:^(id data, NSError *error) {
                                            if (error) {
                                                carImage.uploadState = GGImageUploadStateFail;
                                                [NSObject showStatusBarError:error];
                                                [subscriber sendError:error];
                                            }else{
                                                carImage.uploadState = GGImageUploadStateSuccess;
                                                carImage.photoUrl = [NSString stringWithFormat:@"%@%@",self.qiNiu.domain,data[@"key"]];
                                                DLog(@"上传成功:%@",carImage.photoUrl);
                                                [subscriber sendNext:carImage];
                                                dispatch_group_leave(group);
                                            }
                                        }];
                }else{
                    dispatch_group_leave(group);
                }
            }
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                [subscriber sendCompleted];
            });
            
            return nil;
        }];
        
    }];
    
    //发布
    _releaseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [NSObject showStatusBarQueryStr:@"发布中..."];
        NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:self.imageItems.count];
        for (int i = 0; i < self.imageItems.count; i ++) {
            GGImageItem *carImage = self.imageItems[i];
            if (carImage.uploadState == GGImageUploadStateSuccess) {
                [mDic setObject:carImage.photoUrl forKey:[NSString stringWithFormat:@"photosList[%d].url",i]];
            }
        }
        
        [mDic addEntriesFromDictionary:[self.car modelToJSONObject]];
        
        DLog(@"发布参数:%@",[self.car modelToJSONObject]);
        
        return [[[GGApiManager request_releaseAnCarWithParameter:mDic] map:^id(id value) {
            @strongify(self);
            [self deleteSendDataWithEndBlock:^(BOOL error) {}];
            [NSObject showStatusBarSuccessStr:@"发布成功"];
            return [RACSignal empty];
        }] catch:^RACSignal *(NSError *error) {
            [NSObject showStatusBarError:error];
            return [RACSignal error:error];
        }];
    }];
    
    //获取上传token
    [self.getTokenCommand execute:0];
}

#pragma mark -
- (RACCommand *)getTokenCommand{
    if (!_getTokenCommand) {
        @weakify(self);
        _getTokenCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [[GGApiManager getUploadToken]map:^id(NSDictionary *value) {
                @strongify(self);
                self.qiNiu = [GGQiNiu modelWithDictionary:value];
                return [RACSignal empty];
            }];
        }];
    }
    return _getTokenCommand;
}

- (RACCommand *)reloadData{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            GGFormItem *item = input;
            if (item) {
                if ([item.obj isKindOfClass:[NSDictionary class]]) {
                    [item.obj removeObjectForKey:@"purchaseYear"];
                    [self.car setValuesForKeysWithDictionary:item.obj];
                }else if ([item.obj isKindOfClass:[GGAddress class]]){
                    self.car.address = item.obj;
                }else{
                    [self.car setValue:item.obj forKey:item.propertyName];
                }
            }
            self.dataSource = [self converWithModel:self.car];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
}

- (NSMutableArray *)converWithModel:(GGCar *)model{
    
    NSMutableArray *totalArray = [NSMutableArray array];
    @autoreleasepool {
        for (int i = 0; i < [self.configArray count]; i ++) {
            NSMutableArray *sectionArray = [NSMutableArray array];
            for (int j = 0; j < [self.configArray[i] count]; j ++ ) {
                NSDictionary *configDic = self.configArray[i][j];
                GGFormItem *item = [self itemWithConfigDic:configDic mode:model];
                [sectionArray addObject:item];
            }
            [totalArray addObject:sectionArray];
        }
    }
    
    if (self.car.vinUsed && !self.car.carId) {
        NSMutableArray *sectionArray = totalArray[0];
        [sectionArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 3)]];
    }
    
    return totalArray;
}


- (id)itemWithConfigDic:(NSDictionary *)dic mode:(GGCar *)model{
    GGFormItem *item = [GGFormItem modelWithDictionary:dic];
    item.obj = model ? [model valueForKey:item.propertyName] : nil;
   
    if ([item.propertyName isEqualToString:@"km"]) {
        item.obj = item.obj ? [NSString stringWithFormat:@"%@万公里",item.obj] : nil;
    }

    if ([item.propertyName isEqualToString:@"price"]) {
        item.obj = item.obj ? [NSString stringWithFormat:@"%@万元",item.obj] : nil;
    }
    
    if ([item.propertyName isEqualToString:@"reservePrice"]) {
        item.obj = item.obj ? [NSString stringWithFormat:@"%@元",item.obj] : nil;
    }
    
    
    
    if (item.pageType == GGPageTypeInput) {
        item.pageContent = [GGPersonalInput modelWithDictionary:dic[@"pageContent"]];
    }
    
    if (item.pageType == GGPageTypeVinRecognition) {
        item.pageContent = [GGPersonalInput modelWithDictionary:dic[@"pageContent"]];
    }
    
    if ([item isPicker]) {
        item.pageContent = [GGDatePicker modelWithDictionary:dic[@"pageContent"]];
    }
    
    if (item.pageType == GGPageTypeCarModel) {
        item.pageContent = self.modelList;
    }
    
    return item;
}



#pragma mark - PHAsset
- (void)setAssetArray:(NSMutableArray *)assetArray{
    NSMutableArray *needToAdd = [NSMutableArray new];
    NSMutableArray *needToDelete = [NSMutableArray new];
    
    [self.assetArray bk_all:^BOOL(id obj) {
        if (![assetArray containsObject:obj]) {
            [needToDelete addObject:obj];
        }
        return YES;
    }];
    
    [needToDelete bk_all:^BOOL(PHAsset *obj) {
        [self deletePHAsset:obj];
        return YES;
    }];
    
    [assetArray bk_all:^BOOL(PHAsset *obj) {
        if (![self.assetArray containsObject:obj]) {
            [needToAdd addObject:obj];
        }
        return YES;
    }];
    
    [needToAdd bk_all:^BOOL(PHAsset *obj) {
        [self addAnPHAsset:obj];
        return YES;
    }];
}

- (void)addAnPHAsset:(PHAsset *)asset{
    if (!_assetArray) {
        _assetArray  = [[NSMutableArray alloc] init];
    }
    if (!_imageItems) {
        _imageItems = [[NSMutableArray alloc] init];
    }
    
    [_assetArray addObject:asset];
    
    NSMutableArray *imgItems = [self mutableArrayValueForKey:@"imageItems"];
    GGImageItem *carImg = [GGImageItem imageWithPHAsset:asset];
    [imgItems addObject:carImg];
}

- (void)deletePHAsset:(PHAsset *)asset{
    [self.assetArray removeObject:asset];
    NSMutableArray *imgItems = [self mutableArrayValueForKey:@"imageItems"];//为了kvo
    
    [imgItems bk_all:^BOOL(GGImageItem *obj) {
        if ([obj.photoIdentifier isEqualToString:asset.localIdentifier]) {
            [imgItems removeObject:obj];
            return NO;
        }
        return YES;
    }];
}

#pragma mark - 删除一张
- (void)deleteCarImage:(GGImageItem *)carImg{
    NSMutableArray *imageItems = [self mutableArrayValueForKey:@"imageItems"];//为了kvo
    [imageItems removeObject:carImg];
    if (carImg.photoIdentifier) {
        
        [self.assetArray bk_all:^BOOL(PHAsset *obj) {
            if ([obj.localIdentifier isEqualToString:carImg.photoIdentifier]) {
                [self.assetArray removeObject:obj];
                return NO;
            }
            
            return YES;
        }];
    }
    
}

#pragma mark 判断是否有新的填写
- (BOOL)checkCompare{
    if (self.isEditCar) {
        return YES;
    }
    return [self.rawDic isEqualToDictionary:[self.car modelToJSONObject]];
}

#pragma mark - 判断能不能发布
- (BOOL)canSend{
    if (self.car.vinUsed && !self.isEditCar) {
        [MBProgressHUD showError:@"VIN已使用"];
        return NO;
    }
    
    if ([self.car.reservePrice floatValue] > [self.car.price floatValue] * 10000) {
        [MBProgressHUD showError:@"订金超过总价"];
        return NO;
    }
    
    return YES;
}

#pragma mark - 保存草稿
- (void)saveSendData{
    NSString *dataPath = [NSString stringWithFormat:@"%@_carForSend",[GGLogin shareUser].user.mobile];
    NSMutableDictionary *imageItemsDic = [NSMutableDictionary new];
    for (int i = 0; i < [self.imageItems count]; i ++) {
        GGImageItem *item = self.imageItems[i];
        if (item.imageData) {
            NSString *imgNameStr = [NSString stringWithFormat:@"%@_%d.jpg",dataPath,i];
            if (item.photoIdentifier) {
                [imageItemsDic setObject:item.photoIdentifier forKey:imgNameStr];
            }
            [NSObject saveImage:[UIImage imageWithData:item.imageData] imageName:imgNameStr inFolder:dataPath];
        }
    }
    self.car.carPhotoDict = imageItemsDic;
    [[YYCache cacheWithName:carCacheName] removeObjectForKey:dataPath];
    [[[YYCache cacheWithName:carCacheName] diskCache]setObject:self.car forKey:dataPath];
    
}

#pragma mark - 载入草稿
- (void)loadSendData{
    NSString *dataPath = [NSString stringWithFormat:@"%@_carForSend",[GGLogin shareUser].user.mobile];
    @weakify(self);
    [[YYCache cacheWithName:carCacheName] objectForKey:dataPath withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        @strongify(self);
        if (object) {
            self.car = (GGCar *)object;
            self.rawDic = [self.car modelToJSONObject];
            
            _imageItems = [NSMutableArray new];
            _assetArray = [NSMutableArray new];
            [self.car.carPhotoDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                NSData *imgData = [NSObject loadImageDataWithName:key inFolder:dataPath];
                PHFetchResult *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[obj] options:nil];
                PHAsset *asset = fetchResult.firstObject;
                if (imgData) {
                    GGImageItem *item = [GGImageItem imageWithPHAsset:asset andImage:[UIImage imageWithData:imgData]];
                    [self.imageItems addObject:item];
                }
                [self.assetArray addObject:asset];
            }];
            
            self.dataSource = [self converWithModel:self.car];
            if (self.car.vin.length == 17) {
                [self.vinCommand execute:self.car.vin];
            }
        }
    }];
}

#pragma mark - 删除草稿
- (void)deleteSendDataWithEndBlock:(void(^)(BOOL error))endBlock{
    NSString *dataPath = [NSString stringWithFormat:@"%@_carForSend",[GGLogin shareUser].user.mobile];
    [NSObject deleteImageCacheInFolder:dataPath];
    [[YYCache cacheWithName:carCacheName] removeObjectForKey:dataPath];
    endBlock(NO);
}

- (RACCommand *)vinCommand{
    if (!_vinCommand) {
        @weakify(self);
        _vinCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [[GGApiManager request_getCarModelWithVin:input checkVinExist:YES] map:^id(NSDictionary *value) {
                @strongify(self);
                self.car.vinUsed = [value[@"isExis"] boolValue];
                self.modelList = [NSArray modelArrayWithClass:[GGModelList class] json:value[@"modelList"]];
                return [RACSignal empty];

            }];
        }];
    }
    return _vinCommand;
}


- (NSString *)qiniuKey{
    return [NSString stringWithFormat:@"%@%ld%.6d.jpg",self.qiNiu.namePre,[[NSDate date] second],arc4random_uniform(999999)];
}

- (GGCar *)car{
    if (!_car) {
        _car = [[GGCar alloc] init];
        _car.emissionsId = 5;
        _car.vinUsed = YES;
    }
    return _car;
}

@end
