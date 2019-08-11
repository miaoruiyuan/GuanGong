//
//  CWTAssessResult.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/5/5.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTAssess.h"

@class Chexingku;

@interface CWTAssessResult : CWTAssess

@property (nonatomic , copy) NSString              * price_new;
@property (nonatomic , strong) NSArray<Chexingku *>              * chexingku;

@end


@interface Chexingku :NSObject

@property (nonatomic , copy) NSString              * condition;
@property (nonatomic , copy) NSString              * sellprice;
@property (nonatomic , strong) NSArray<NSString *> * desc;
@property (nonatomic , copy) NSString              * buyprice;

@end
