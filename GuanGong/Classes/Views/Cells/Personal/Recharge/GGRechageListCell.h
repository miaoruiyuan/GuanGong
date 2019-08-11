//
//  GGRechageListCell.h
//  GuanGong
//
//  Created by CodingTom on 2017/7/18.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGTableViewCell.h"
#import "GGBankRechargeRateModel.h"

UIKIT_EXTERN NSString * const kGGRechageListCellID;

@interface GGRechageListCell : GGTableViewCell

- (void)updateUIWithModel:(GGBankRechargeRateModel *)model;

@end
