//
//  GGSearchFriendResultViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/5.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGSearchFriendResultViewController.h"
#import "GGFriendInfoViewController.h"
#import "GGMyFriendsCell.h"

@interface GGSearchFriendResultViewController ()

@end

@implementation GGSearchFriendResultViewController

- (void)bindViewModel{
    [RACObserve(self, searchResults)subscribeNext:^(id x) {
        [self.baseTableView reloadData];
    }];
}
- (void)setupView{
    [self.baseTableView registerClass:[GGMyFriendsCell class] forCellReuseIdentifier:kCellIdentifierMyFeiend];
}


#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGMyFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierMyFeiend];
    GGFriendsList *friend = self.searchResults[indexPath.row];
    cell.list = friend;
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        GGFriendsList *friend = self.searchResults[indexPath.row];
        if (self.SearchAction) {
            self.SearchAction (friend);
        }
    }];

}


@end
