//
//  CWTVinResultCell.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/20.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWTVinResult.h"

UIKIT_EXTERN NSString *const kCellIdentifierVinResultCell;

@interface CWTVinResultCell : UITableViewCell

@property(nonatomic,strong)CWTVinResult *vinResult;

@end
