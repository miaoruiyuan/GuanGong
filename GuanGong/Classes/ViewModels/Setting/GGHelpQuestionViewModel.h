//
//  GGHelpListViewModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"
#import "GGHelpListModel.h"
#import "GGHelpQuestionTypeModel.h"

@class GGFeedbackRequestModel;

@interface GGHelpQuestionViewModel : GGTableViewModel

@property(nonatomic,strong,readonly)RACCommand *getHelpListCommand;
@property(nonatomic,strong,readonly)RACCommand *getHelpTypesCommand;
@property(nonatomic,strong,readonly)RACCommand *feedbackCommand;

@property(nonatomic,strong)GGFeedbackRequestModel *feedbackModel;

- (NSString *)getFeedbackHeaderTitle;

@end

@interface GGFeedbackRequestModel : NSObject

@property(nonatomic,assign)NSInteger questionTypeId;
@property(nonatomic,strong)NSString *phoneModel;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *sysVersion;

@end
