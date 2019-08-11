//
//  GGManagerAddressViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGManagerAddressViewController.h"
#import "GGAddAddressViewController.h"
#import "GGEditAddressCell.h"
#import "GGAddressViewModel.h"

@interface GGManagerAddressViewController ()

@property(nonatomic,strong)GGFormItem *item;
@property(nonatomic,strong)UIButton *addButton;
@property(nonatomic,strong)GGAddressViewModel *addressVM;

@end

@implementation GGManagerAddressViewController

- (instancetype)initWithItem:(GGFormItem *)item{
    if (self = [super init]) {
        self.item = item;
    }
    return self;
}

- (void)setupView{
    self.navigationItem.title = @"地址管理";
    self.enabledRefreshHeader = YES;
    self.emptyDataTitle = @"暂无相关地址";
    [self.baseTableView registerClass:[GGEditAddressCell class] forCellReuseIdentifier:kCellIdentifierEditAddress];
    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.addButton.mas_top);
    }];
    
    //添加地址
    @weakify(self);
    [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        GGAddAddressViewController *addAddressVC = [[GGAddAddressViewController alloc] init];
        [addAddressVC setPopHandler:^(NSNumber *number) {
            @strongify(self);
            [self refresh];
            if (self.popHandler) {
                self.popHandler(@1);
            }
        }];
        [GGManagerAddressViewController presentVC:addAddressVC];
    }];
}

- (void)bindViewModel{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self refresh];
    @weakify(self);
    [[self.addressVM.loadData.executing skip:1]subscribeNext:^(NSNumber *x) {
        @strongify(self);
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
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } completed:^{
        @strongify(self);
        [self endRefreshHeader];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self.baseTableView reloadData];
    }];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.addressVM.addressList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGEditAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierEditAddress];
    GGAddress *item = self.addressVM.addressList[indexPath.section];
    
    //设为默认地址
    @weakify(self);
    [cell setSetDefultAddressBlock:^{
        @strongify(self);
        [[self.addressVM.defultAdressCommand execute:item.addressId]subscribeCompleted:^{
            @strongify(self);
            [self refresh];
        }];
    }];
    
    //编辑地址
    [cell setEditAddressBlock:^{
        GGAddAddressViewController *addAddressVC = [[GGAddAddressViewController alloc] init];
        addAddressVC.value = item;
        [addAddressVC setPopHandler:^(NSNumber *number) {
            @strongify(self);
            [self refresh];
        }];
        [GGManagerAddressViewController presentVC:addAddressVC];
    }];
    
    //删除一个地址
    [cell setDeteleAdressBlock:^{
        [UIAlertController alertInController:self title:@"确定删除该地址?" message:nil confrimBtn:@"确定" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
            @strongify(self);
            [[self.addressVM.deleteCommand execute:item.addressId]subscribeCompleted:^{
                @strongify(self);
                [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
                [self refresh];
            }];
        } cancelBtn:@"取消" cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
    }];
    
    cell.address = item;
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self);
    return [tableView fd_heightForCellWithIdentifier:kCellIdentifierEditAddress cacheByIndexPath:indexPath configuration:^(GGEditAddressCell *cell) {
        @strongify(self);
        cell.address = self.addressVM.addressList[indexPath.section];
    }];
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        [_addButton setTitle:@"添加地址" forState:UIControlStateNormal];
        [_addButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightLight]];
    }
    return _addButton;
}

- (GGAddressViewModel *)addressVM{
    if (!_addressVM) {
        _addressVM = [[GGAddressViewModel alloc] init];
    }
    return _addressVM;
}

@end
