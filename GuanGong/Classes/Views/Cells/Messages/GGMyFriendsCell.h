//
//  GGMyFriendsCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/4.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGFriendsList.h"

UIKIT_EXTERN NSString * const kCellIdentifierMyFeiend;

@interface GGMyFriendsCell : UITableViewCell

- (void)setUpView;

@property(nonatomic,strong)GGFriendsList *list;

@end
