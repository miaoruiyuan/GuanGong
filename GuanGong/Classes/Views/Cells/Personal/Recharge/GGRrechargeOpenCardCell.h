//
//  GGRrechargeOpenCardCell.h
//  GuanGong
//
//  Created by CodingTom on 2017/7/25.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGTableViewCell.h"
#import "GGBankRechargeListModel.h"

UIKIT_EXTERN NSString * const kGGRrechargeOpenCardCellID;

@interface GGRrechargeOpenCardCell : GGTableViewCell

- (void)showRechargeBankCard:(GGBankRechargeListModel *)model;

@end
