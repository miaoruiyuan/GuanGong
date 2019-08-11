//
//  GGCarAddressViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarAddressViewController.h"
#import "GGManagerAddressViewController.h"
#import "GGAddressViewModel.h"
#import "GGCarAddressCell.h"

@interface GGCarAddressViewController ()
@property(nonatomic,strong)GGAddressViewModel *addressVM;
@property(nonatomic,strong)GGFormItem *item;

@end

@implementation GGCarAddressViewController

- (instancetype)initWithItem:(GGFormItem *)item{
    if (self = [super init]) {
        self.item = item;
    }
    return self;
}

- (void)setupView{
    self.navigationItem.title = @"看车地址";
    self.style = UITableViewStylePlain;
    self.enabledRefreshHeader = YES;
    self.emptyDataTitle = @"暂无看车地址";
    self.emptyDataMessage = @"点击右上角添加";
    [self.baseTableView registerClass:[GGCarAddressCell class] forCellReuseIdentifier:kCellIdentifierCarAddress];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"管理" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        GGManagerAddressViewController *managerVC = [[GGManagerAddressViewController alloc] initWithItem:self.item];
        [managerVC setPopHandler:^(NSNumber *value) {
            [self refresh];
        }];
        [self pushTo:managerVC];
    }];
}


- (void)bindViewModel{
    [self refresh];
    
    @weakify(self);
    [[self.addressVM.loadData.executing skip:1] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if ([x isEqualToNumber:@(YES)]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        }
        self.emptyDataDisplay = !x.boolValue;
    }];
}

- (void)refreshHeaderAction{
    [self refresh];
}

- (void)refresh{
    @weakify(self);
    [[self.addressVM.loadData execute:nil] subscribeError:^(NSError *error) {
        @strongify(self);
        [self endRefreshHeader];
    } completed:^{
        @strongify(self);
        [self endRefreshHeader];
        [self.baseTableView reloadData];
    }];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressVM.addressList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGCarAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCarAddress];
    cell.address = self.addressVM.addressList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:kCellIdentifierCarAddress cacheByIndexPath:indexPath configuration:^(GGCarAddressCell *cell) {
        cell.address = self.addressVM.addressList[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGAddress *address = self.addressVM.addressList[indexPath.row];
    self.item.obj = address;
    
    if (self.popHandler) {
        self.popHandler(self.item);
    }
    [self pop];
}

- (GGAddressViewModel *)addressVM{
    if (!_addressVM) {
        _addressVM = [[GGAddressViewModel alloc] init];
        if ([self.item.obj isKindOfClass:[GGAddress class]]) {
            _addressVM.defaultSelectedAddress = (GGAddress *)self.item.obj;
        }
    }
    return _addressVM;
}


@end
