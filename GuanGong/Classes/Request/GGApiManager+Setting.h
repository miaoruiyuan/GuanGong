//
//  GGApiManager+Setting.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGApiManager.h"

@interface GGApiManager(Setting)

#pragma mark - 问题反馈
/**
 获取帮助问题列表
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_GetHelpListWithParameter:(NSDictionary *)parameter;


/**
 （反馈）帮助类型列表
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_GetHelpTypesWithParameter:(NSDictionary *)parameter;

/**
 反馈问题 feedback
 @param parameter parameter description
 @return return value description
 */

+ (RACSignal *)request_QuestionFeedbackWithParameter:(NSDictionary *)parameter;


@end
