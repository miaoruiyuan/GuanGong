//
//  GGMyFriendsViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMyFriendsViewController.h"
#import "GGSearchFriendResultViewController.h"
@interface GGMyFriendsViewController ()

@property(nonatomic,strong)GGSearchFriendResultViewController *resultVc;

@end

@implementation GGMyFriendsViewController


- (void)bindViewModel{
    //先去数据库找
    [self.friensVM.loadDBdata execute:0];
    [self.friensVM.loadData execute:0];
    @weakify(self);
    [RACObserve(self.friensVM, dataSource)subscribeNext:^(id x) {
        @strongify(self);
        [self.baseTableView reloadData];
    }];

    [[self.friensVM.loadData.executing skip:1]subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.emptyDataDisplay = !x.boolValue;
    }];
    
}

- (void)setupView{
    self.navigationItem.title = @"兄弟";
    self.emptyDataTitle  = @"您还没有好友";
    self.style = UITableViewStylePlain;
    [self.baseTableView registerClass:[GGMyFriendsCell class] forCellReuseIdentifier:kCellIdentifierMyFeiend];
    [self.baseTableView registerClass:[GGTableHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kViewIdentifierHeaderFooterView];
    self.baseTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.baseTableView.sectionIndexColor = textLightColor;
    self.baseTableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
}


#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return [self.friensVM sectionCount];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.friensVM itemCountAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GGMyFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierMyFeiend];

    GGFriendsList *friend = [self.friensVM itemForIndexPath:indexPath];
    cell.list = friend;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GGTableHeaderFooterView *vHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kViewIdentifierHeaderFooterView];
  
    vHeader.title = self.friensVM.indexTitles[section + 1];
    return vHeader;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return self.friensVM.indexTitles;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (index == 0) {
        CGRect searchBarFrame = self.searchController.searchBar.frame;
        [tableView scrollRectToVisible:searchBarFrame animated:NO];
        return NSNotFound;
    }
    return index-1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGFriendsList *friend = [self.friensVM itemForIndexPath:indexPath];
    
    if (friend.auditingType != FriendAuditPass) {
        kTipAlert(@"对方为未认证,暂时无法转账");
        return;
    }
    
   
    //申请代付
    @weakify(self);
    if (self.friensVM.applyAmount){
        @strongify(self);
        if ([friend.contactId isEqualToNumber:self.friensVM.salerId]) {
            kTipAlert(@"卖家不能作为付款方");
            return;
        }
        
        [UIAlertController alertInController:self title:@"" message:[NSString stringWithFormat:@"申请%@为您代付%@元",friend.realName,self.friensVM.applyAmount] confrimBtn:@"确认" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
            
            [[self.friensVM.applyPayCommand execute:friend.contactId]subscribeCompleted:^{
                [MBProgressHUD showSuccess:@"申请成功" toView:self.view];
                
                [self bk_performBlock:^(GGMyFriendsViewController *obj) {
                    
                    [obj dismissViewControllerAnimated:NO completion:^{
                        if (self.popHandler) {
                            self.popHandler(@1);
                        }
                    }];
                   
                } afterDelay:1.1];
            }];
            
        } cancelBtn:@"取消" cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
        
        return;
    }
    
    
    
    GGAccount *account = [[GGAccount alloc]init];
    account.realName = friend.realName;
    account.icon = friend.iconUrl;
    account.mobile = friend.mobile;
    account.userId = friend.contactId;
    
    GGTransferViewController *transferVC = [[GGTransferViewController alloc] initWithItem:account];
    transferVC.transferVM.isTransfer = self.isTransfer;
    transferVC.transferVM.isFinalPay = NO;
    [self pushTo:transferVC];
}


#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    NSString *searchStr = searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mobile CONTAINS %@ OR realName CONTAINS[cd] %@ OR remark CONTAINS[cd] %@", searchStr,searchStr,searchStr];
    
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSArray *array in self.friensVM.dataSource) {
        NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
        
        for (GGFriendsList *friend in filteredArray) {
            [mArr addObject:friend];
        }
        
    }
    
    self.resultVc.searchResults = mArr;
}


- (UISearchController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultVc];
        _searchController.view.backgroundColor = [UIColor whiteColor];
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.frame = CGRectMake(0, 0,self.view.width, 40);
        _searchController.searchBar.placeholder = @"搜索联系人";
        [_searchController.searchBar setBackgroundImage:[UIImage imageWithColor:tableBgColor]
                                         forBarPosition:0
                                             barMetrics:UIBarMetricsDefault];
        _searchController.searchBar.tintColor = themeColor;
        _searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchController.dimsBackgroundDuringPresentation = NO;
        UITextField *searchField = [_searchController.searchBar valueForKey:@"searchField"];
        searchField.backgroundColor = [UIColor whiteColor];
        
    }
    return _searchController;
}

- (GGMyFriendsViewModel *)friensVM{
    if (!_friensVM) {
        _friensVM = [[GGMyFriendsViewModel alloc]init];
    }
    return _friensVM;
}

- (GGSearchFriendResultViewController *)resultVc{
    if (!_resultVc) {
        _resultVc =[[GGSearchFriendResultViewController alloc] init];
        @weakify(self);
        [_resultVc setSearchAction:^(GGFriendsList *item) {
            @strongify(self);
            self.searchController.active = NO;
            GGFriendInfoViewController *friendInfoVC = [[GGFriendInfoViewController alloc]init];
            friendInfoVC.dealerId = item.contactId;
            [self pushTo:friendInfoVC];
        }];
    }
    return _resultVc;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

@end
