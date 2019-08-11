//
//  GGCar.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCar.h"

@implementation GGCar

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"carId": @"id",
             @"xinCarId": @"newCarId"
             };
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
    if (dic[@"address"]) {
        [dic setObject:dic[@"address"][@"id"] forKey:@"addressId"];
        [dic setObject:dic[@"address"][@"provinceId"] forKey:@"provinceId"];
        [dic setObject:dic[@"address"][@"cityId"] forKey:@"cityId"];
    }
    
    [dic setObject:@([[dic objectForKey:@"price"] floatValue] * 10000 ) forKey:@"price"];
    [dic removeObjectsForKeys:@[@"photosList",@"carPhotoDict",@"userId",@"vinUsed",@"updateTime",@"address"]];
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self modelEncodeWithCoder:aCoder];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self modelInitWithCoder:aDecoder];
}

@end

