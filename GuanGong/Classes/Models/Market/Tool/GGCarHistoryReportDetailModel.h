//
//  GGCarHistoryReportDetailModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/14.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGCarHistoryReportDetailModel : NSObject

@property (nonatomic , copy) NSString              *title;
@property (nonatomic , copy) NSString              *createTime;

@property (nonatomic , copy) NSString              *vin;
@property (nonatomic , copy) NSString              *reportUrl;
@property (nonatomic , copy) NSString              *failMessage;

@property (nonatomic , assign) BOOL              isReturn;
@property (nonatomic , strong) NSNumber            *reportId;
//1生成中，2暂无记录，3暂无记录，4已完成，5暂无记录
@property (nonatomic , strong) NSNumber            *reportStatus;

@end
