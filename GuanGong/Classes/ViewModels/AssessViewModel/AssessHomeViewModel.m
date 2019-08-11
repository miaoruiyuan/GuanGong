//
//  AssessHomeViewModel.m
//  bluebook
//
//  Created by three on 2017/5/3.
//  Copyright © 2017年 iautos_miaoruiyuan. All rights reserved.
//

#import "AssessHomeViewModel.h"
#import "NSArray+Common.h"
#import "GGFormItem.h"
#import "DatePickerModel.h"
#import "CityLocationManager.h"
#import "GGToolApiManager.h"

@interface AssessHomeViewModel ()

@property(nonatomic,strong)NSArray *configArray;


@end

@implementation AssessHomeViewModel

-(CWTAssess *)assessModel
{
    if (!_assessModel) {
        _assessModel = [[CWTAssess alloc] init];
        
        if ([self.assessModel.city_id integerValue] == 1000) {
            self.assessModel.city_name = @"北京";
            self.assessModel.city_id = @"828";
        }
        
    }
    return _assessModel;
}

-(void)initialize
{
    [super initialize];
    self.configArray = [NSArray configArrayWithResource:@"AssessVM"];
    self.dataSource = [self converWithModel:self.assessModel];
    [self initBind];
}

- (NSMutableArray *)converWithModel:(CWTAssess *)model{
    
    NSMutableArray *totalArray = [NSMutableArray array];
    @autoreleasepool {
        for (int i = 0; i < [self.configArray count]; i ++) {
            NSMutableArray *sectionArray = [NSMutableArray array];
            for (int j = 0; j < [self.configArray[i] count]; j ++ ) {
                NSDictionary *configDic = self.configArray[i][j];
                GGFormItem *item = [self itemWithConfigDic:configDic model:model];
                [sectionArray addObject:item];
            }
            [totalArray addObject:sectionArray];
        }
    }
    return totalArray;
}

- (id)itemWithConfigDic:(NSDictionary *)dic model:(id)model{
    GGFormItem *item = [GGFormItem modelWithDictionary:dic];
    
    CWTAssess *assessModel = (CWTAssess*)model;
    if (item.pageType == GGPageTypeCityList) {
        if (model) {
            if (assessModel.city_id) {
                NSDictionary *dict = @{@"city_id":assessModel.city_id,
                                       @"city_name":assessModel.city_name ,
                                       @"city_proper_id":assessModel.city_proper_id ,
                                       @"city_proper_name":assessModel.city_proper_name ,
                                       @"province_id":assessModel.province_id ,
                                       @"province_name":assessModel.province_name
                                       };
                item.obj = dict;
            }else{
                item.obj = self.assessModel.city_name;
                item.showText = self.assessModel.city_name;
            }
        }
    }else if (item.pageType == GGPageTypeCarModel){
        DLog(@"%@",item);
        if (assessModel.modelSimpleId) {
            NSString *brandName = @"";
            if (assessModel.brandName != nil) {
                brandName = assessModel.brandName;
            }
            
            NSString *seriesName = @"";
            if (assessModel.seriesName != nil) {
                seriesName = assessModel.seriesName;
            }
           
            item.obj = [NSString stringWithFormat:@"%@款 %@%@%@",assessModel.version_year,brandName,seriesName,assessModel.modelSimpleName];
        }else{
            item.obj = nil;
        }
    }else{
        item.obj = model ? [model valueForKey:item.propertyName] : nil;
    }
    
    
    if (item.pageType == GGPageTypeInput) {
        if([item.propertyName isEqualToString:@"mileage"]){
            item.showText = assessModel.mileage.description;
        }
    }
    
    if ([item isPicker]) {
        if (assessModel.purchaseYear) {
            NSDictionary *yearDict = @{@"min_year":assessModel.purchaseYear};
            item.pageContent = yearDict;
        }
    }
    return item;
}

-(void)initBind{
    
    _enableAssessSignal = [RACSignal combineLatest:@[RACObserve(self ,assessModel.city_id),
                                                     RACObserve(self, assessModel.modelSimpleId),
                                                     RACObserve(self, assessModel.first_reg_date),
                                                     RACObserve(self, assessModel.mileage)]
                                            reduce:^id(NSNumber *cityId,NSNumber *modelId,NSString *regDate,NSString *km){
                                                return @(modelId && regDate && km.floatValue > 0);
                                            }];
    @weakify(self);
    _assessCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        @strongify(self);
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"user_id"] = [GGLogin shareUser].user.userId;
        params[@"purchase_year"] = self.assessModel.purchaseYear;
        params[@"model_simple_id"] = self.assessModel.modelSimpleId;
        params[@"mileage"] = self.assessModel.mileage;
        params[@"first_reg_date"] = self.assessModel.first_reg_date;
        
        if (self.assessModel.city_id == nil) {
             self.assessModel.city_id = @"828";
        }
        params[@"city_id"] = self.assessModel.city_id;
        
        return [[GGToolApiManager carPriceAssessWithParames:params] map:^id(id value) {
            @strongify(self);
            self.assessResult = [CWTAssessResult modelWithDictionary:value];
            self.assessResult.purchase_year = self.assessModel.purchaseYear;;
            self.assessResult.city_id = self.assessModel.city_id;
            self.assessResult.model_simple_id = self.assessModel.modelSimpleId;
    
            return [RACSignal empty];
        }];
    
    }];
}

-(RACCommand *)reloadData
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            GGFormItem *item = input;
            if (item) {
                if ([item.obj isKindOfClass:[NSDictionary class]]) {
                    [self.assessModel setValuesForKeysWithDictionary:item.obj];
                }else{
                    [self.assessModel setValue:item.obj forKey:item.propertyName];
                }
            }
            self.dataSource = [self converWithModel:self.assessModel];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
}


@end
