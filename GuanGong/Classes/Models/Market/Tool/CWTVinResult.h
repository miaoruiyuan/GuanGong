//
//  CWTVinResult.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/20.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWTVinResult : NSObject

@property (nonatomic , strong) NSArray<NSString *> *config;
@property (nonatomic , copy) NSString              *version;
@property (nonatomic , copy) NSString              *price;
@property (nonatomic , copy) NSString              *trimName;
@property (nonatomic , copy) NSString              *trimId;

@property(nonatomic  , copy)NSString               *fdjh;
@property(nonatomic  , copy)NSString               *ccrq;

@property(nonatomic,copy)NSString                  *vin;

//是否存在多个VIN结果
@property(nonatomic,assign)BOOL                  moreChoose;

@end
