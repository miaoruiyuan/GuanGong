//
//  CWTAssessBaseInfoCell.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/5/3.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWTAssessResult.h"

@class OtherInfoView;

UIKIT_EXTERN NSString *const kCellIdentifierAssessBaseInfo;

@interface CWTAssessBaseInfoCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIView *lastInfoView;
@property(nonatomic,strong)MASConstraint *bottomConstraint;

@property(nonatomic,strong)CWTAssessResult *result;

- (void)configItemWithObj:(CWTAssess *)obj;
- (void)setupView;

@end


@interface OtherInfoView : UIView

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *valueLabel;

@end


