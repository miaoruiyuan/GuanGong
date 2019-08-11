//
//  CWTAssessResult.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/5/5.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTAssessResult.h"

@implementation CWTAssessResult

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"chexingku" : [Chexingku class]};
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    [dic removeObjectsForKeys:@[@"title",@"province_name",@"city_name",@"update_time",@"localSaveID",@"modelSimpleName",@"brandName",@"seriesName",@"city_proper_id",@"city_proper_name",@"is_history",@"chexingku",@"price_new"]];
    
    if (self.log_id) {
        [dic setObject:self.log_id forKey:@"log_id"];
    }
    
    return YES;
}

@end


@implementation Chexingku

@end
