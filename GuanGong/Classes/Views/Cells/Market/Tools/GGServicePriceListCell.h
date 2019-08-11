//
//  GGServicePriceListCell.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/12.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSearvicePriceListModel.h"

UIKIT_EXTERN NSString *const kGGServicePriceListCellID;

@interface GGServicePriceListCell : UITableViewCell

@property (nonatomic,strong)UIButton *buyBtn;

- (void)updateUIWithModel:(GGSearvicePriceListModel *)model;

@end
