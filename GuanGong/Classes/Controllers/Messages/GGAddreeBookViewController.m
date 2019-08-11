//
//  GGAddreeBookViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/5.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGAddreeBookViewController.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
#import "GGAddressBookUtil.h"
#import "GGFriendInfoViewController.h"
#import "GGAddressBookCell.h"
#import "GGTableHeaderFooterView.h"
#import "GGAddressBook.h"
#import "GGDataBaseManager.h"

@interface GGAddreeBookViewController ()<UISearchResultsUpdating,MFMessageComposeViewControllerDelegate>
{
    NSMutableDictionary             *_contactPeapleDic;
    NSMutableArray                  *_contactPeapleABC;
}
@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)NSArray *addressBooks;
@property(nonatomic,strong)NSMutableArray *searchResultArray;
@property(nonatomic,strong)RACCommand *addFriendCommand;

@end

@implementation GGAddreeBookViewController

- (void)bindViewModel
{
    @weakify(self);
    [RACObserve(self, searchResultArray)subscribeNext:^(id x) {
        @strongify(self);
        [self.baseTableView reloadData];
    }];
}

- (void)setupView
{
    self.navigationItem.title = @"通讯录";

    [self loadAddressBook];

    [self.baseTableView registerClass:[GGTableHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kViewIdentifierHeaderFooterView];
    self.baseTableView.tableHeaderView = self.searchController.searchBar;
    self.baseTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.baseTableView.sectionIndexColor = textLightColor;
    self.definesPresentationContext = YES;
    
    [self createTableDataSource];
    [self.baseTableView reloadData];
}

- (void)createTableDataSource
{
    self.addressBooks = [NSArray modelArrayWithClass:[GGAddressBook class] json:[[GGDataBaseManager shareDB] getAddressBookLists]];
    [self sortContacts:self.addressBooks];
}

- (void)sortContacts:(NSArray *)dataSource
{
    _contactPeapleDic = [[NSMutableDictionary alloc] init];
    _contactPeapleABC = [[NSMutableArray alloc] init];
    
    for (GGAddressBook *model in dataSource) {
        NSString *pinyin = [model getUserNamePinYin];
        pinyin = [pinyin uppercaseString];
        if (pinyin) {
            NSComparisonResult min = [pinyin compare:@"A"];
            NSComparisonResult max = [pinyin compare:@"Z"];
            if (min == NSOrderedAscending || max == NSOrderedDescending) {
                pinyin = @"#";
            }
        }else{
            pinyin = @"#";
        }
        
        if ([_contactPeapleDic objectForKey:pinyin]) {
            [[_contactPeapleDic objectForKey:pinyin] addObject:model];
        }else{
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [array addObject:model];
            [_contactPeapleDic setObject:array forKey:pinyin];
            [_contactPeapleABC addObject:pinyin];
        }
    }
    
    int telPhoneCount = (int)_contactPeapleABC.count;
    if (telPhoneCount == 0) {
        return;
    }
    
    for (int i = 0; i < telPhoneCount - 1; i ++) {
        for (int j = i+1; j < telPhoneCount; j++) {
            NSComparisonResult result=[_contactPeapleABC[i] compare:_contactPeapleABC[j]];
            if (result == NSOrderedDescending) {
                [_contactPeapleABC exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
}


- (void)loadAddressBook
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted ||ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied){
        [UIAlertView bk_showAlertViewWithTitle:@"提示"
                                       message:@"您没有授权通讯录访问,请到设置里打开"
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil
                                       handler:nil];
    }else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined){
        ABAddressBookRequestAccessWithCompletion(NULL, ^(bool granted, CFErrorRef error){
            if (granted){
                [GGAddressBookUtil loadPhoneContactsToDB];
                [self createTableDataSource];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.baseTableView reloadData];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIAlertView bk_showAlertViewWithTitle:@"提示"
                                                   message:@"您没有授权通讯录访问,请到设置里打开"
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil
                                                   handler:nil];
                });
            }
        });
        
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.active){
        return 1;
    }
    return _contactPeapleABC.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active){
        return self.searchResultArray.count;
    }
    return [_contactPeapleDic[_contactPeapleABC[section]] count];
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.searchController.active) {
        return nil;
    }
    return _contactPeapleABC;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGAddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierAddressBook];
    if (!cell) {
        cell = [[GGAddressBookCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:kCellIdentifierAddressBook];

    }
    
    GGAddressBook *book;
    if (self.searchController.active ) {
        book = self.searchResultArray[indexPath.row];
    }else{
        book = _contactPeapleDic[_contactPeapleABC[indexPath.section]][indexPath.row];
    }
    
    cell.textLabel.text = book.fullname;
    cell.detailTextLabel.text = book.mobile;
    
    @weakify(self);
    [[[cell.addButton rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        @strongify(self);
        [MBProgressHUD showMessage:@"请稍后" toView:self.view];
        book.mobile =  [book.mobile stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [[self.addFriendCommand execute:book.mobile]subscribeNext:^(id x) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:self.view];
        } error:^(NSError *error) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:self.view];
            id errorCode = error.userInfo[@"responseCode"];
            if ([errorCode isKindOfClass:[NSNumber class]]) {
                errorCode = [errorCode stringValue];
            }
            
            if([error isKindOfClass:[NSString class]] && [errorCode isEqualToString:@"101008"] ){
                [UIAlertController alertInController:self title:@"对方不是关二爷用户" message:nil confrimBtn:@"去邀请" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
                    
                    [self sendMessageTo:book.mobile];
                } cancelBtn:@"取消" cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
            }
            
        }];
    }];
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.searchController.active) {
        return nil;
    }
    GGTableHeaderFooterView *vHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kViewIdentifierHeaderFooterView];
    vHeader.title = _contactPeapleABC[section];
    return vHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.searchController.active) {
        return 0.01;
    }
    return 22;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:12];
}


#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.searchResultArray removeAllObjects];
    
    NSString *searchStr = searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullname CONTAINS %@ OR lastname CONTAINS[cd] %@ OR firstname CONTAINS[cd] %@ OR mobile CONTAINS[cd] %@", searchStr,searchStr,searchStr,searchStr];
    
    self.searchResultArray = [[self.addressBooks filteredArrayUsingPredicate:predicate] mutableCopy];
}


#pragma mark - 短信邀请
- (void)sendMessageTo:(NSString *)mobile{
    
    MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
    messageVC.recipients = @[mobile];
    messageVC.body = @"嗨，怎么还没注册【关二爷 - 二手车商担保支付平台】呢？赶快去AppStore下载一个试试吧。";
    messageVC.messageComposeDelegate = self;
    [self presentViewController:messageVC animated:YES completion:nil];
}

#pragma mark -MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [controller dismissViewControllerAnimated:NO completion:^{
        
        switch (result) {
            case MessageComposeResultCancelled:
                [MBProgressHUD showError:@"取消发送" toView:self.view];
                break;
                
            case MessageComposeResultSent:
                [MBProgressHUD showError:@"发送成功" toView:self.view];
                break;
                
                
            case MessageComposeResultFailed:
                [MBProgressHUD showError:@"发送失败" toView:self.view];
                break;
                
            default:
                break;
        }
        
        
    }];
    
}


- (RACCommand *)addFriendCommand{
    if (!_addFriendCommand) {
        @weakify(self);
        _addFriendCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSString *input) {
            return [[GGApiManager request_CheckFriendInfo_WithMobile:input] map:^id(NSDictionary *value) {
                @strongify(self);
                GGFriendInfoViewController *friendInfoVC = [[GGFriendInfoViewController alloc]init];
                friendInfoVC.friendInfo = [GGFriendInfo modelWithDictionary:value];
                [self pushTo:friendInfoVC];
                return [RACSignal empty];
            }];
        }];
    }
    return _addFriendCommand;
}

- (UISearchController *)searchController{
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.frame = CGRectMake(0, 0,self.view.width, 40);
        _searchController.searchBar.placeholder = @"搜索通讯录联系人";
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


- (NSArray *)addressBooks{
    if (!_addressBooks) {
        _addressBooks = [NSArray array];
    }
    return _addressBooks;
}

- (NSMutableArray *)searchResultArray{
    if (!_searchResultArray) {
        _searchResultArray = [NSMutableArray array];
    }
    return _searchResultArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}


@end
