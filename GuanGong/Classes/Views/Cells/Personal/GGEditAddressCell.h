//
//  GGEditAddressCell.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGAddressViewModel.h"

UIKIT_EXTERN NSString * const kCellIdentifierEditAddress;

@interface GGEditAddressCell : UITableViewCell

@property(nonatomic,strong)GGAddress *address;

@property (nonatomic,copy)void(^setDefultAddressBlock)();
@property (nonatomic,copy)void(^editAddressBlock)();
@property (nonatomic,copy)void(^deteleAdressBlock)();

@end
