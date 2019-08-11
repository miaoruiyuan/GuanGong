//
//  GGOtherPayDetailInfoCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/8/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGOtherPayDetail.h"

UIKIT_EXTERN NSString * const kCellIdentifierOtherPayDetailInfo;
@interface GGOtherPayDetailInfoCell : UITableViewCell

@property(nonatomic,strong)GGOtherPayDetail *payDetail;
@property(nonatomic,assign)BOOL isMineApply;

@end
