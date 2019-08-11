//
//  CWTVinReport.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/22.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWTVinReport : NSObject

@property (nonatomic , copy) NSString              * html_id;
@property (nonatomic , assign)BOOL                 is_old;
@property (nonatomic , assign)NSInteger            main_tain_status;
@property (nonatomic , copy) NSString              * main_tain_content;
@property (nonatomic , copy) NSString              * car_vin;
@property (nonatomic , copy) NSString              * car_model;
@property (nonatomic , copy) NSString              * create_time;
@property (nonatomic , copy) NSString              * master_id;

@end
