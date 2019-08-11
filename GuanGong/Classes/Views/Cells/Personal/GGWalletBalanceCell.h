//
//  GGWalletBalanceCell.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/12.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGWallet.h"


UIKIT_EXTERN NSString *const kCellIdentifierWalletBalance;

@interface GGWalletBalanceCell : UITableViewCell

@property(nonatomic,strong)GGWallet *wallet;

@end
