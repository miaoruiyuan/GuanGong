//
//  GGVinResultDetailModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/27.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGVinResultDetailModel : NSObject

@property (nonatomic , copy) NSString              *vinQueryId;
@property (nonatomic , copy) NSString              *vin;
@property (nonatomic , copy) NSString              *modelName;
@property (nonatomic , copy) NSString              *modelId;
@property (nonatomic , copy) NSString              *title;
@property (nonatomic , copy) NSString              *detailUrl;
@property (nonatomic , copy) NSString              *createTime;

@end
