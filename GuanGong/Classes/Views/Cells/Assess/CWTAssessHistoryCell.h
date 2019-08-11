//
//  CWTAssessHistoryCell.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/5/3.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTAssessBaseInfoCell.h"

UIKIT_EXTERN NSString *const kCellIdentifierAssessHistory;

@interface CWTAssessHistoryCell : CWTAssessBaseInfoCell

@property(nonatomic,strong)UIView *bottomLine;
@property(nonatomic,strong)UILabel *dateLabel;

@end
