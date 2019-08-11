//
//  GGBrandCardCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGBankCard.h"

UIKIT_EXTERN NSString * const kCellIdentifierBankCardCell;

@interface GGBankCardCell : UITableViewCell

@property(nonatomic,strong)GGBankCard *card;

@end
