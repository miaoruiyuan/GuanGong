//
//  GGCarOrderOtherInfoCell.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/30.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCarOrderDetail.h"

UIKIT_EXTERN NSString * const kCellIdentifierCarOrderOtherInfo;

@interface GGCarOrderOtherInfoCell : UITableViewCell

@property(nonatomic,strong)GGCarOrderDetail *orderDetail;

@end
