//
//  GGWithdrawCashCardCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGBankCard.h"
#import "GGBankRechargeListModel.h"

UIKIT_EXTERN NSString * const kCellIdentifierWithdrawCashCell;

@interface GGWithdrawCashCardCell : UITableViewCell

@property(nonatomic,strong)GGBankCard *bankCard;

- (void)showCheckBank:(GGBankCard *)bankCard;

- (void)showRechargeView:(GGBankRechargeListModel *)model;

@end
