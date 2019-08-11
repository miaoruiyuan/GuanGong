//
//  GGBankAddressViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/23.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBankAddressViewController.h"
#import "GGOnlyLabelCell.h"
#import "GGBankAddress.h"

@interface GGBankAddressViewController ()<UISearchResultsUpdating>

@property(nonatomic,strong)GGFormItem *item;

@property(nonatomic,strong)UISearchController *searchController;

@property(nonatomic,strong)NSMutableArray *addressData;
@property(nonatomic,strong)NSMutableArray *searchAddressData;

@property(nonatomic,strong)RACCommand *bankAddressCommand;

@end

@implementation GGBankAddressViewController


-(instancetype)initWithItem:(GGFormItem *)item{
    if (self = [super init]) {
        self.item = item;
    }
    return self;
}

- (void)setupView{
    self.navigationItem.title = @"开户网点";
    [self.baseTableView registerClass:[GGOnlyLabelCell class] forCellReuseIdentifier:kCellIdentifierOnlyLabel];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    [headerView addSubview:self.searchController.searchBar];
    self.baseTableView.tableHeaderView = headerView;
    
    self.emptyDataTitle = @"目前没有符合的开户网点";
    self.enabledRefreshHeader = YES;
    
    [self beginHeaderRefreshing];
    
}
- (void)bindViewModel{
    [RACObserve(self, addressData)subscribeNext:^(id x) {
        [self.baseTableView reloadData];
    }];
    
    [RACObserve(self, searchAddressData)subscribeNext:^(id x) {
        [self.baseTableView reloadData];
    }];
    
    [[self.bankAddressCommand.executing skip:1]subscribeNext:^(NSNumber *x) {
        self.emptyDataDisplay = !x.boolValue;
    }];
    
}

- (void)refreshHeaderAction{
    [[self.bankAddressCommand execute:nil]subscribeError:^(NSError *error) {
         [self endRefreshFooter];
         [self endRefreshHeader];
    } completed:^{
        [self endRefreshHeader];
        [self endRefreshFooter];
    }];
}


#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchController.active ? self.searchAddressData.count : self.addressData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGOnlyLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierOnlyLabel];
    GGBankAddress *address = self.searchController.active ? self.searchAddressData[indexPath.row] : self.addressData[indexPath.row];
    cell.label.text = address.bankName;
    return cell;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:12];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:kCellIdentifierOnlyLabel cacheByIndexPath:indexPath configuration:^(GGOnlyLabelCell *cell) {
        GGBankAddress *address = self.searchController.active ? self.searchAddressData[indexPath.row] : self.addressData[indexPath.row];
        cell.label.text = address.bankName;
    }];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GGBankAddress *address = self.searchController.active ? self.searchAddressData[indexPath.row] : self.addressData[indexPath.row];
    self.item.obj = address;
    if (self.popHandler) {
        self.popHandler(self.item);
    }
    
    self.searchController.active = NO;
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.searchAddressData removeAllObjects];
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"bankName CONTAINS[cd] %@", searchController.searchBar.text];
    self.searchAddressData = [[self.addressData filteredArrayUsingPredicate:searchPredicate] mutableCopy];
}

- (RACCommand *)bankAddressCommand{
    if (!_bankAddressCommand) {
        _bankAddressCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [[GGApiManager request_getBankAddressWithParames:self.item.obj]map:^id(NSDictionary *value) {
                self.addressData = [[NSArray modelArrayWithClass:[GGBankAddress class] json:value]mutableCopy];
                return [RACSignal empty];
            }];
        }];
    }
    return _bankAddressCommand;
}


- (NSMutableArray *)addressData{
    if (!_addressData) {
        _addressData = [[NSMutableArray alloc]init];
    }
    return _addressData;
}

- (NSMutableArray *)searchAddressData{
    if (!_searchAddressData) {
        _searchAddressData = [[NSMutableArray alloc] init];
    }
    return _searchAddressData;
}

- (UISearchController *)searchController{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.frame = CGRectMake(0, 0,self.view.width, 40);
        _searchController.searchBar.placeholder = @"搜索";
        [_searchController.searchBar setBackgroundImage:[UIImage imageWithColor:tableBgColor]
                                         forBarPosition:0
                                             barMetrics:UIBarMetricsDefault];
        _searchController.searchBar.tintColor = themeColor;
        _searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchController.dimsBackgroundDuringPresentation = NO;
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
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
