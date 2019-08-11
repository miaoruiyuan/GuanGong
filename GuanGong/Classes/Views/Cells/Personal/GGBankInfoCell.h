//
//  GGBankInfoCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/14.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGBank.h"

UIKIT_EXTERN NSString * const kCellIdentifierBankInfo;

@interface GGBankInfoCell : UITableViewCell

@property(nonatomic,strong)GGBank *bank;

@end
