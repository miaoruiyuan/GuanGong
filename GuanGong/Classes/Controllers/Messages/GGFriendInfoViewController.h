//
//  GGFriendInfoViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewController.h"
#import "GGFriendInfo.h"
#import "GGFriendsList.h"

@interface GGFriendInfoViewController : GGTableViewController

@property(nonatomic,strong)NSNumber *dealerId;

@property(nonatomic,strong)GGFriendsList *friendListInfo;
@property(nonatomic,strong)GGFriendInfo *friendInfo;

@end
