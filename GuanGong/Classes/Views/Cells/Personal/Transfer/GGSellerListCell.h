//
//  GGSellerListCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/18.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPaymentOrderCell.h"

@protocol SellerCellDelegate <NSObject>

- (void)sellerCellAction:(UIButton *)sender;

@end

UIKIT_EXTERN NSString * const kCellIdentifierSellerList;
@interface GGSellerListCell : GGPaymentOrderCell

@property(nonatomic,assign)id<SellerCellDelegate> delegate;

@end
