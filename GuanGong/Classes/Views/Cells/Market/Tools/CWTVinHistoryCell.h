//
//  CWTVinHistoryCell.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/21.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWTVinHistory.h"
#import "CWTMaintainHistory.h"

UIKIT_EXTERN NSString *const kCellIdentifierVinHistoryCell;

@interface CWTVinHistoryCell : UITableViewCell

@property(nonatomic,strong)CWTVinHistory *history;

@property(nonatomic,strong)CWTMaintainHistory *maintainHistory;

@end
