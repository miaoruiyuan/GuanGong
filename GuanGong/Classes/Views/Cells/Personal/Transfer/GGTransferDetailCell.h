//
//  GGTransferDetailCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGTransferAccountViewModel.h"

UIKIT_EXTERN NSString * const kCellIdentifierTransferDetails;

@interface GGTransferDetailCell : UITableViewCell


@property(nonatomic,strong)GGTransferAccountViewModel *accountVM;


@end

