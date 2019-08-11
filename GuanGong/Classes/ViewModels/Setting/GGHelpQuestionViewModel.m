//
//  GGHelpListViewModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGHelpQuestionViewModel.h"
#import "GGApiManager+Setting.h"

@implementation GGHelpQuestionViewModel

- (void)initialize
{
    @weakify(self);
    _getHelpListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *value) {
        //isHot: 是否热门 0-否 1-是
        return [[GGApiManager request_GetHelpListWithParameter:@{@"isHot":@"1"}] map:^id(id value) {
            DLog(@"%@",value);
            
            @strongify(self);
            NSArray *data = value[@"result"];
            NSArray *result = [NSArray modelArrayWithClass:[GGHelpListModel class] json:data];
            self.dataSource = [result mutableCopy];
            return [RACSignal empty];
        }];
    }];
    
    _getHelpTypesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *value) {
        return [[GGApiManager request_GetHelpTypesWithParameter:@{}] map:^id(id value) {
            
            @strongify(self);
            NSArray *result = [NSArray modelArrayWithClass:[GGHelpQuestionTypeModel class] json:value];
            self.dataSource = [result mutableCopy];
            return [RACSignal empty];
        }];
    }];
    
    _feedbackCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *value) {
        @strongify(self);
        NSDictionary *dic = [self.feedbackModel modelToJSONObject];
        return [[GGApiManager request_QuestionFeedbackWithParameter:dic] map:^id(id value) {
            return [RACSignal empty];
        }];
    }];
    
    self.feedbackModel = [[GGFeedbackRequestModel alloc] init];
}

#pragma mark - dataSource

- (GGHelpListModel *)itemForIndexPath:(NSIndexPath *)indexPath
{
    return self.dataSource[indexPath.row];
}

- (NSInteger)itemCountAtSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (NSInteger)sectionCount
{
    return 1;
}


#pragma mark -  

- (NSString *)getFeedbackHeaderTitle
{
    NSString *version = [[UIApplication sharedApplication] appVersion];
    return  [NSString stringWithFormat:@"设备:%@  系统:%@  客户端版本:%@",self.feedbackModel.phoneModel,self.feedbackModel.sysVersion,version];
}

@end

@implementation GGFeedbackRequestModel

- (NSString *)phoneModel
{
    return [UIDevice currentDevice].model;
}

- (NSString *)sysVersion
{
    return [UIDevice currentDevice].systemVersion;
}

@end
