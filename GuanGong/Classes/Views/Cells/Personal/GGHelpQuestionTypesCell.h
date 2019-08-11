//
//  GGHelpQuestionTypesCell.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/24.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGTableViewCell.h"

UIKIT_EXTERN NSString *const kGGHelpQuestionTypesCellID;

@interface GGHelpQuestionTypesCell : GGTableViewCell

- (void)showWithTypeArray:(NSArray *)typeArray;

- (void)typeSelectedBlock:(void(^)(NSInteger index))block;

+ (CGFloat)getCellHight:(NSArray *)typeArray;

@end
