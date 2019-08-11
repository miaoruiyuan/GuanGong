//
//  GGSearchFriendResultViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/5.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewController.h"
#import "GGFriendsList.h"

@interface GGSearchFriendResultViewController : GGTableViewController<UISearchResultsUpdating>
@property(nonatomic,strong)NSArray *searchResults;

@property(nonatomic,copy)void(^SearchAction)(GGFriendsList *item);

@end
