//
//  GGWarrantCarViewModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/2/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGWarrantCarViewModel.h"
#import "GGCheckCar.h"

@implementation GGWarrantCarViewModel

- (void)initializeRac
{
    RACSignal *enableSignal = [RACSignal combineLatest:@[RACObserve(self.checkCar, vin),
                                                         RACObserve(self.checkCar, titleL),
                                                         RACObserve(self.checkCar,cityStr),
                                                         RACObserve(self.checkCar.user, realName),
                                                         RACObserve(self.checkCar.user, mobile)] reduce:^id(NSString *vin,NSString *model, NSString *city ,NSString *name,NSString *phone){
                                                             return @(vin.length > 0 && model && city && name.length > 0 && phone.length > 0);
                                                         }];
    
    @weakify(self);
    //提交质检
    _appointmentCommand = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal *(id input) {

        @strongify(self);
        GGCheckCar *submitCar = [self carToCheckCar:self.checkCar];
        NSDictionary *jsonObj = [submitCar modelToJSONObject];
        [jsonObj bk_each:^(id key, id obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [submitCar setValuesForKeysWithDictionary:obj];
            }
        }];
        NSDictionary *parameter = [submitCar modelToJSONObject];
        
        return [[GGApiManager request_appointmentCheckCarWithParames:parameter]map:^id(NSDictionary *value) {
            
            return [RACSignal empty];
        }];
    }];
}

- (void)setCheckCar:(GGCar *)checkCar
{
    _checkCar = checkCar;
    GGFormItem *item0 = [[GGFormItem alloc] init];
    item0.title = @"车辆 VIN";
    item0.propertyName = checkCar.vin;
    
    GGFormItem *item1 = [[GGFormItem alloc] init];
    item1.title = @"检测车辆";
    item1.propertyName = checkCar.titleL;

    GGFormItem *item2 = [[GGFormItem alloc] init];
    item2.title = @"检测地点";
    item2.propertyName = checkCar.cityStr;

    
    GGFormItem *item3 = [[GGFormItem alloc] init];
    item3.title = @"联  系  人";
    item3.propertyName = checkCar.user.realName;
    
    GGFormItem *item4 = [[GGFormItem alloc] init];
    item4.title = @"联系电话";
    item4.propertyName = checkCar.user.mobile;

    self.dataSource = @[item0,item1,item2,item3,item4];
    [self initializeRac];
}

- (GGCheckCar *)carToCheckCar:(GGCar *)car
{
    GGCheckCar *submitCar = [[GGCheckCar alloc] init];
    submitCar.vin = car.vin;
    submitCar.brandId = car.brandId;
    submitCar.seriesId = car.seriesId;
    submitCar.modelId = car.modelId;
    submitCar.title = car.title;
    submitCar.carCity = car.cityId;
    submitCar.carProvince = car.provinceId;
    
    submitCar.saleName = car.user.userName;
    submitCar.saleTel = car.user.mobile;
    return submitCar;
}

@end
