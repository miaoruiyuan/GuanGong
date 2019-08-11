//
//  CWTAssessPriceInfoCell.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/5/3.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWTAssessResult.h"
UIKIT_EXTERN NSString *const kCellIdentifierAssessPriceInfo;
@interface CWTAssessPriceInfoCell : UITableViewCell
@property(nonatomic,strong)CWTAssessResult *result;
@end
