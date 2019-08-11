//
//  CWTRecognitionVin.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/4/1.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWTRecognitionVin : NSObject

@property (nonatomic , copy) NSString              * owner;
@property (nonatomic , copy) NSString              * issue_date;
@property (nonatomic , copy) NSString              * register_date;
@property (nonatomic , copy) NSString              * vehicle_type;
@property (nonatomic , copy) NSString              * vin;
@property (nonatomic , copy) NSString              * model;
@property (nonatomic , copy) NSString              * plate_num;
@property (nonatomic , copy) NSString              * request_id;
@property (nonatomic , assign) BOOL                success;
@property (nonatomic , copy) NSString              * config_str;
@property (nonatomic , copy) NSString              * engine_num;

@end
