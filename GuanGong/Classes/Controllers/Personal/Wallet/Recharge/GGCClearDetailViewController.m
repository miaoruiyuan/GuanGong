
//
//  GGCClearDetailViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCClearDetailViewController.h"
#import "GGCapitalClearViewModel.h"
#import "GGCapitalClearStateCell.h"
#import "GGCapitalClearInfoCell.h"
#import "GGTopMessageView.h"

@interface GGCClearDetailViewController ()

@property(nonatomic,strong)GGCapitalClearList *clearList;
@property(nonatomic,strong)GGCapitalClearViewModel *capitalClearVM;
@property(nonatomic,assign)NSInteger sectionCount;

@end

@implementation GGCClearDetailViewController


- (id)initWithObject:(GGCapitalClearList *)list
{
    if (self = [super init]) {
        self.clearList = list;
    }
    return self;
}

- (void)bindViewModel
{
    [self.capitalClearVM.detailCommand execute:self.clearList.applyId];
    @weakify(self);
    [[RACObserve(self.capitalClearVM, clearDetail) skip:1]subscribeNext:^(GGCapitalClearList *x) {
       @strongify(self);
        self.sectionCount = 2;
        if (x.auditRemark.length > 0) {
            self.baseTableView.tableHeaderView = [GGTopMessageView initWithMessage:x.auditRemark];
        }
        [self.baseTableView reloadData];
    }];
}

- (void)setupView
{
    self.navigationItem.title = @"申请详情";
    self.baseTableView.sectionHeaderHeight = 0.01;
    self.baseTableView.sectionFooterHeight = 14;
    [self.baseTableView registerClass:[GGCapitalClearStateCell class] forCellReuseIdentifier:kCellIdentifierClearState];
    [self.baseTableView registerClass:[GGCapitalClearInfoCell class] forCellReuseIdentifier:kCellIdentifierClearInfo];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GGCapitalClearStateCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierClearState];
        cell.state = self.capitalClearVM.clearDetail.status;
        return cell;
    }else{
        GGCapitalClearInfoCell *cell =[tableView dequeueReusableCellWithIdentifier:kCellIdentifierClearInfo];
        cell.clearDetail = self.capitalClearVM.clearDetail;
        return cell;
    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 46;
    }else{
        return [tableView fd_heightForCellWithIdentifier:kCellIdentifierClearInfo configuration:^(GGCapitalClearInfoCell *cell) {
            cell.clearDetail = self.capitalClearVM.clearDetail;
        }];
    }
}

- (GGCapitalClearViewModel *)capitalClearVM
{
    if (!_capitalClearVM) {
        _capitalClearVM = [[GGCapitalClearViewModel alloc] init];
    }
    return _capitalClearVM;
}

@end
