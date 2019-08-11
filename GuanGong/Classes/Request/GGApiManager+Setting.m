//
//  GGApiManager+Setting.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGApiManager+Setting.h"

@implementation GGApiManager(Setting)

#pragma mark - 获取帮助列表

+ (RACSignal *)request_GetHelpListWithParameter:(NSDictionary *)parameter{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"question/questionList"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
}

+ (RACSignal *)request_GetHelpTypesWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"question/questionTypeList"
                                                   withParams:parameter
                                                     andBlock:^(id data, NSError *error) {
                                                         if (error) {
                                                             [subscriber sendError:error];
                                                         }else{
                                                             [subscriber sendNext:data];
                                                             [subscriber sendCompleted];
                                                         }
                                                     }];
    
        return nil;
    }];
    
}

+ (RACSignal *)request_QuestionFeedbackWithParameter:(NSDictionary *)parameter
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"question/questionFeedback"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 [subscriber sendError:error];
                                                             }else{
                                                                 [subscriber sendNext:data];
                                                                 [subscriber sendCompleted];
                                                             }
                                                         }];
        
        return nil;
    }];
}

@end
