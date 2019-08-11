//
//  GGFriendInfoCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/9/2.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const kCellIdentifierFeiendInfo;

@interface GGFriendInfoCell : UITableViewCell

- (void)updateUIWithTitle:(NSString *)title value:(NSString *)value;

@end
