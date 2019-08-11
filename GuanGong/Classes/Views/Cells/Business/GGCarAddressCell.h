//
//  GGCarAddressCell.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGAddressViewModel.h"

UIKIT_EXTERN NSString *const kCellIdentifierCarAddress;

@interface GGCarAddressCell : UITableViewCell

@property(nonatomic,strong)GGAddress *address;

@end
