//
//  CWTMaintainHistory.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/21.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWTMaintainHistory : NSObject


@property (nonatomic , copy) NSString              *isReturn;
@property (nonatomic , copy) NSString              *reportId;
@property (nonatomic , copy) NSString              *title;
@property (nonatomic , copy) NSString              *vin;
@property (nonatomic , copy) NSString              *reportStatusName;
//1生成中，2暂无记录，3暂无记录，4已完成，5暂无记录
@property (nonatomic , assign) NSInteger           reportStatus;
@property (nonatomic , copy) NSString              *reportDataJsonId;
@property (nonatomic , copy) NSString              *failMessage;
@property (nonatomic , copy) NSString              *createTime;

@end
