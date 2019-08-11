//
//  GGRemarkCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IQKeyboardManager/IQTextView.h>
#import "GGHelpQuestionViewModel.h"

UIKIT_EXTERN NSString * const kCellIdentifierRemarkCell;

@interface GGRemarkCell : UITableViewCell

@property(nonatomic,strong)IQTextView *remarkTextView;

- (void)updateUIWithFeedbackModel:(GGFeedbackRequestModel *)model;

@end
