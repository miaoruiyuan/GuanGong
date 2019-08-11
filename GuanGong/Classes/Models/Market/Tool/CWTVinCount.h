//
//  CWTVinCount.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/21.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWTVinCount : NSObject

@property (nonatomic , assign)NSInteger              has_search_sum;
@property (nonatomic , assign)NSInteger             total_num;
@property (nonatomic , copy) NSString              * update_time;
@property (nonatomic , copy) NSString              * shop_product_type_id;

@property (nonatomic , copy) NSString              * create_time;
@property (nonatomic , copy) NSString              * shop_id;
@property (nonatomic , copy) NSString              * shop_product_info;
@property (nonatomic , copy) NSString              * user_id;
@property (nonatomic , copy) NSString              * service_business_info;

@end
