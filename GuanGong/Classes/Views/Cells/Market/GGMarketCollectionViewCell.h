//
//  GGMarketCollectionViewCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/9/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGMarketItem.h"

UIKIT_EXTERN NSString *const kCellIdentifierMarketCCell;

@interface GGMarketCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)GGMarketItem *item;

@end
