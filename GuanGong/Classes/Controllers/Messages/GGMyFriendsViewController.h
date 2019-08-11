//
//  GGMyFriendsViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewController.h"
#import "GGTransferViewController.h"
#import "GGFriendInfoViewController.h"
#import "GGMyFriendsViewModel.h"
#import "GGMyFriendsCell.h"
#import "GGTableHeaderFooterView.h"
#import "GGFriendsList.h"

@interface GGMyFriendsViewController : GGTableViewController<UISearchResultsUpdating>
@property(nonatomic,assign)BOOL isTransfer;

@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)GGMyFriendsViewModel *friensVM;

@end
