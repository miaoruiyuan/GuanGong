
//
//  GGCheckCarViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckCarViewModel.h"
#import "GGCarBrand.h"

@interface GGCheckCarViewModel ()
@property(nonatomic,strong)NSArray *configArray;


@end

@implementation GGCheckCarViewModel

- (void)initialize{
    self.configArray = [NSArray configArrayWithResource:@"CheckCar"];
    self.dataSource = [self converWithModel:self.checkCar];
    
   
    RACSignal *enableSignal = [RACSignal combineLatest:@[RACObserve(self.checkCar, vin),
                                                         RACObserve(self.checkCar, title),
                                                         RACObserve(self.checkCar, carCity),
                                                         RACObserve(self.checkCar, saleName),
                                                         RACObserve(self.checkCar, saleTel)] reduce:^id(NSString *vin,NSString *model, NSString *city ,NSString *name,NSString *phone){
                                                             
                                                             
                                                             
                                                             
        return @(vin.length > 0 && model && city && name.length > 0 && phone.length > 0);
    }];
    
    

    @weakify(self);
    //提交质检
    _appointmentCommand = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSDictionary *jsonObj = [self.checkCar modelToJSONObject];
        [jsonObj bk_each:^(id key, id obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [self.checkCar setValuesForKeysWithDictionary:obj];
            }
        }];
        
        NSDictionary *parameter = [self.checkCar modelToJSONObject];
        return [[GGApiManager request_appointmentCheckCarWithParames:parameter]map:^id(NSDictionary *value) {
            
            return [RACSignal empty];
        }];
    }];

    
}


-(NSMutableArray *)converWithModel:(GGCheckCar *)model{
    
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
    
    return totalArray;
}


-(id)itemWithConfigDic:(NSDictionary *)dic mode:(id)model{
    GGFormItem *item = [GGFormItem modelWithDictionary:dic];
    item.obj = model ? [model valueForKey:item.propertyName] : nil;
    
    if (item.pageType == GGPageTypeInput) {
        item.pageContent = [GGPersonalInput modelWithDictionary:dic[@"pageContent"]];
    }
    
    return item;
}


- (RACCommand *)reloadData{
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            GGFormItem *item = input;
            if (item) {
                if ([item.obj isKindOfClass:[NSDictionary class]]) {
                    [self.checkCar setValuesForKeysWithDictionary:item.obj];
                }else{
                    [self.checkCar setValue:item.obj forKey:item.propertyName];
                }
            }
            
            self.dataSource  = [self converWithModel:self.checkCar];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
}

- (RACCommand *)vinCommand{
    if (!_vinCommand) {
        _vinCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
            return [[GGApiManager request_autoDiscriminateCarWithVin:input]map:^id(NSArray *value) {
                NSArray *array = [NSArray modelArrayWithClass:[GGCarModel class] json:value];
                if (array.count > 0) {
                    GGCarModel *model = array[0];
                    self.checkCar.title = [NSString stringWithFormat:@"%@%@",model.brand_name,model.series_name];
                    self.checkCar.seriesId = model.series_id;
                    self.checkCar.brandId = model.brand_id;
                    [self.reloadData execute:nil];
                }
                
                return [RACSignal empty];
            }];
        }];
    }
    return _vinCommand;
}


- (GGCheckCar *)checkCar{
    if (!_checkCar) {
        _checkCar = [[GGCheckCar alloc] init];
    }
    return _checkCar;
}


@end
