//
//  GGBuyerListCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/18.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPaymentOrderCell.h"

@protocol BuyerCellDelegate <NSObject>

- (void)buyerCellAction:(UIButton *)sender;

@end

UIKIT_EXTERN NSString * const kCellIdentifierBuyerList;

@interface GGBuyerListCell : GGPaymentOrderCell

@property(nonatomic,assign)id<BuyerCellDelegate> delegate;

@end
