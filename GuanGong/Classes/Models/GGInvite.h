//
//  GGInvite.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGInvite : NSObject

@property(nonatomic,copy)NSString *mobilePhone;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *realName;

@property(nonatomic,assign)NSInteger auditingType;

@property(nonatomic,strong)NSNumber *userId;

@end
