//
//  GGGoodsInfoCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/9.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGGoodsInfo.h"


UIKIT_EXTERN NSString * const kCellIdentifierGoodsInfo;
@interface GGGoodsInfoCell : UITableViewCell

@property(nonatomic,strong)GGGoodsInfo *goodInfo;


@end
