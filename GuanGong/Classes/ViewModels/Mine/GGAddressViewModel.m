//
//  GGAddAddressViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGAddressViewModel.h"

@interface GGAddressViewModel ()

@property(nonatomic,strong)NSArray *configArray;

@end

@implementation GGAddressViewModel

- (void)initialize
{
    self.configArray = [NSArray configArrayWithResource:@"EditAddress"];
    self.dataSource = [self converWithModel:self.address];
    //获取 地址 列表
    @weakify(self);
    self.loadData = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[GGApiManager request_getAddressList]map:^id(id value) {
            @strongify(self);
            [self.addressList removeAllObjects];
            [self.addressList addObjectsFromArray:[NSArray modelArrayWithClass:[GGAddress class] json:value]];
            if (self.defaultSelectedAddress) {
                [self.addressList enumerateObjectsUsingBlock:^(GGAddress *address, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([address.addressId isEqualToNumber:self.defaultSelectedAddress.addressId]) {
                        address.isListSelected = YES;
                        *stop = YES;
                    }
                }];
            }
            return [RACSignal empty];
        }];
    }];
}

- (NSMutableArray *)converWithModel:(GGAddress *)model
{
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

- (id)itemWithConfigDic:(NSDictionary *)dic mode:(id)model
{
    GGFormItem *item = [GGFormItem modelWithDictionary:dic];
    item.obj = model ? [model valueForKey:item.propertyName] : nil;
    
    if (item.pageType == GGPageTypeInput) {
        item.pageContent = [GGPersonalInput modelWithDictionary:dic[@"pageContent"]];
    }
    return item;
}

- (RACCommand *)reloadData
{
    @weakify(self);
    return [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            GGFormItem *item = input;
            if (item) {
                if ([item.obj isKindOfClass:[NSDictionary class]]) {
                    [self.address setValuesForKeysWithDictionary:item.obj];
                }else{
                    [self.address setValue:item.obj forKey:item.propertyName];
                }
            }
            self.dataSource  = [self converWithModel:self.address];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
}

#pragma mark - 添加地址 or 修改地址
- (RACCommand *)updateData
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSDictionary *parames = [self.address modelToJSONObject];
        if (self.address.addressId) {
            return [[GGApiManager request_editAddressWithParames:parames] map:^id(id value) {
                return [RACSignal empty];
            }];
        } else {
            return [[GGApiManager request_addNewAddressWithParames:parames] map:^id(NSDictionary *value) {
                return [RACSignal empty];
            }];
        }
    }];
}

#pragma mark - 设为默认地址
- (RACCommand *)defultAdressCommand{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *addressId) {
        return [[GGApiManager request_setDefultAddressWithAddressId:addressId] map:^id(id value) {
            return [RACSignal empty];
        }];
    }];
}

#pragma mark - 删除地址
- (RACCommand *)deleteCommand{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *addressId) {
        return [[GGApiManager request_deleteAnAddressWithAddressId:addressId] map:^id(id value) {
            return [RACSignal empty];
        }];
    }];
}

- (GGAddress *)address{
    if (!_address) {
        _address = [[GGAddress alloc] init];
    }
    return _address;
}

- (NSMutableArray *)addressList{
    if (!_addressList) {
        _addressList = [[NSMutableArray alloc] init];
    }
    return _addressList;
}

@end

@implementation GGAddress

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"addressId":@"id"};
}

// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    return YES;
}

// 当 Model 转为 JSON 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self modelEncodeWithCoder:aCoder];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self modelInitWithCoder:aDecoder];
}

@end
