//
//  GGHelpListModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGHelpListModel : NSObject

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *url;

@property(nonatomic,copy)NSString *questionId;

@property(nonatomic,assign)NSInteger status;
@property(nonatomic,assign)NSInteger isHot;
@property(nonatomic,assign)NSInteger priority;

@end
