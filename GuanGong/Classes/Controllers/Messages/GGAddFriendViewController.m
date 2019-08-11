//
//  GGAddFriendViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/5.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGAddFriendViewController.h"
#import "GGAddreeBookViewController.h"
#import "GGFriendInfoViewController.h"
#import "GGMineQrCodeViewController.h"
#import "GGScanCodeViewController.h"
#import "GGSearchFriendView.h"
#import "GGAddressBookUtil.h"

@interface GGAddFriendViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)GGSearchFriendView *headerView;
@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong,readonly)RACCommand *searchFriendCommand;

@end

@implementation GGAddFriendViewController

- (void)bindViewModel{
    
    @weakify(self);
    _searchFriendCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
        return [[GGApiManager request_CheckFriendInfo_WithMobile:input] map:^id(NSDictionary *value) {
            @strongify(self);
            GGFriendInfoViewController *friendInfoVC = [[GGFriendInfoViewController alloc] init];
            friendInfoVC.friendInfo = [GGFriendInfo modelWithDictionary:value];
            [self pushTo:friendInfoVC];
            return [RACSignal empty];
        }];
    }];
}

- (void)setupView{
    self.navigationItem.title = @"添加朋友";
    self.baseTableView.tableHeaderView = self.headerView;

    @weakify(self);
    [self.headerView bk_whenTapped:^{
        @strongify(self);
        [self presentViewController:self.searchController animated:YES completion:nil];
    }];
    [GGAddressBookUtil loadPhoneContactsToDB];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"addCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15.8];
        cell.detailTextLabel.textColor = textLightColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"addressBook_contacts"];
            cell.textLabel.text = @"手机联系人";
            cell.detailTextLabel.text = @"添加通讯录联系人";
            break;
            
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"addressBook_scan"];
            cell.textLabel.text = @"扫一扫";
            cell.detailTextLabel.text = @"通过扫描添加联系人";
            break;

            
        default:
            cell.imageView.image = [UIImage imageNamed:@"addressBook_mineQr"];
            cell.textLabel.text = @"我的二维码";
            cell.detailTextLabel.text = @"我的二维码";
            break;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:18];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        GGAddreeBookViewController *booksVC = [[GGAddreeBookViewController alloc]init];
        [self pushTo:booksVC];
        [MobClick event:@"contactaddfriend"];
    }else if (indexPath.row == 1){
        GGScanCodeViewController *scanCodeVC = [[GGScanCodeViewController alloc]init];
        scanCodeVC.scanResultBlock =  ^(GGScanCodeViewController *vc, NSString *resultStr){
            [MBProgressHUD showSuccess:@"查找中..." toView:self.view];
            if (!resultStr) {
                [MBProgressHUD showError:@"二维码无效" toView:self.view];
                return ;
            }
           [self searchFriendInfoWithMobile:resultStr];
        };
        [self pushTo:scanCodeVC];
        [MobClick event:@"scanaddfriend"];
    }else{
        GGMineQrCodeViewController *mineQrVC = [[GGMineQrCodeViewController alloc] init];
        [self pushTo:mineQrVC];
        [MobClick event:@"qrcode"];
    }
}


- (GGSearchFriendView *)headerView{
    if (!_headerView) {
        _headerView = [[GGSearchFriendView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 48)];
    }
    return _headerView;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [MobClick event:@"searchaddfriend"];
    NSString *kw = [[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]stringByReplacingOccurrencesOfString:@" " withString:@""];

    [self.searchController dismissViewControllerAnimated:YES completion:^{
        if ([kw isEqualToString:[GGLogin shareUser].user.mobile]) {
            [MBProgressHUD showError:@"不能添加自己为好友哦" toView:self.view];
            return ;
        }
        [MBProgressHUD showMessage:@"查找中..." toView:self.view];
        [self searchFriendInfoWithMobile:kw];
    }];

    DLog(@"____%@",kw);
}

#pragma mark - 查找是否存在关二爷用户
- (void)searchFriendInfoWithMobile:(NSString *)mobile{
    @weakify(self);
    [[self.searchFriendCommand execute:mobile]subscribeError:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } completed:^{
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (UISearchController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchBar.frame = CGRectMake(0, 0,self.view.width, 40);
        _searchController.searchBar.delegate = self;
        _searchController.searchBar.placeholder = @"查找联系人";
        [_searchController.searchBar setBackgroundImage:[UIImage imageWithColor:tableBgColor] forBarPosition:0 barMetrics:UIBarMetricsDefault];
        _searchController.searchBar.tintColor = themeColor;
        _searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
        UITextField *searchField = [_searchController.searchBar valueForKey:@"searchField"];
        searchField.backgroundColor = [UIColor whiteColor];
    }
    return _searchController;
}

@end
