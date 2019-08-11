//
//  CWTAssess.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/1/4.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTAssess.h"

@implementation CWTAssess

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    [dic removeObjectsForKeys:@[@"title",@"title_l",@"emissions_name",@"province_name",@"city_name",@"create_time",@"update_time",@"emissions_name",@"localSaveID",@"title",@"title_l",@"modelSimpleName",@"brandName",@"seriesName",@"province_id",@"city_proper_id",@"city_proper_name",@"is_history"]];
    
    if (self.log_id) {
        [dic setObject:self.log_id forKey:@"log_id"];
    }
    
    
    return YES;
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"log_id":@"id"};
}

-(NSString *)province_id
{
    return @"";
}

-(NSString *)province_name
{
    return @"";
}

-(NSString *)city_proper_id
{
    return @"";
}

-(NSString *)city_proper_name
{
    return @"";
}





//- (NSNumber *)shop_id{
//    return [CWTUserManager shareUser].shop.shopId;
//}
//
//- (NSString *)user_id{
//    return [CWTUserManager shareUser].user.user_id;
//}
@end
