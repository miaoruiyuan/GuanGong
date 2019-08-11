//
//  GGCheckUpdateModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/3/8.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGCheckUpdateModel : NSObject

@property(nonatomic,copy)NSArray *changeLogs;
@property(nonatomic,copy)NSString *publishdate;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *version;
@property(nonatomic,copy)NSString *remark;

- (BOOL)showUpdate;

@end
