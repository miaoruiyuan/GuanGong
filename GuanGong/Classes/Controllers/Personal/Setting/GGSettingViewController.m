//
//  GGSettingViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGSettingViewController.h"

#import "GGSecuritySettingViewController.h"

#import "GGTitleValueCell.h"
#import "GGSettingViewModel.h"

@interface GGSettingViewController ()

@property(nonatomic,strong)GGSettingViewModel *settingVM;

@end

@implementation GGSettingViewController


- (void)setupView{
//    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navigationItem.title = @"设置";
    
    [self.baseTableView registerClass:[GGTitleValueCell class] forCellReuseIdentifier:kCellIdentifierTitleValue];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)bindViewModel{
    @weakify(self);
    [RACObserve(self.settingVM, dataSource)subscribeNext:^(id x) {
        @strongify(self);
        [self.baseTableView reloadData];
    }];
    [self getDiskCacheSize];
}

#pragma mark TableM
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.settingVM sectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.settingVM itemCountAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGFormItem *item = [self.settingVM itemForIndexPath:indexPath];
    GGTitleValueCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTitleValue];
    [cell configItem:item];
    
    if ([item.title isEqualToString:@"退出登录"]) {
        [cell.contentView removeAllSubviews];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, cell.height)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = item.title;
        [cell.contentView addSubview:textLabel];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:{
            GGSecuritySettingViewController *secusityVC = [[GGSecuritySettingViewController alloc]init];
            [self.navigationController pushViewController:secusityVC animated:YES];
        }
            break;
        case 1:{
            [[YYWebImageManager sharedManager].cache.diskCache removeAllObjectsWithBlock:^() {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showSuccess:@"已清除" toView:self.view];
                    [self getDiskCacheSize];
                });
            }];
        }
            break;
        case 2:{
            [self userLogout];
        }
            
        default:
            break;
    }
}

- (void)userLogout{
    [UIAlertController actionSheetInController:self title:@"退出当前帐号?" message:nil confrimBtn:@[@"确认"] confrimStyle:UIAlertActionStyleDefault confrimAction:^(UIAlertAction *action, NSInteger index) {
        @weakify(self)
        [[[self.settingVM logoutCommand] execute:@{@"appName":GGAppName}] subscribeNext:^(id x) {
            [[GGLogin shareUser] logOut];
        } error:^(NSError *error) {
            @strongify(self);
            [MBProgressHUD showSuccess:@"退出失败请重试！" toView:self.view];
        }];
    } cancelBtn:@"取消" cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
}

- (GGSettingViewModel *)settingVM{
    if (!_settingVM) {
        _settingVM = [[GGSettingViewModel alloc]init];
    }
    return _settingVM;
}

- (void)getDiskCacheSize
{
    @weakify(self); 
    [[YYWebImageManager sharedManager].cache.diskCache totalCostWithBlock:^(NSInteger totalCost) {
        CGFloat total = totalCost / 1024.0 / 1024.0;
        NSString *totalString = [NSString stringWithFormat:@"%0.2fMB",total];
        @strongify(self);
        if (self.settingVM.dataSource.count > 0) {
            GGFormItem *item = self.settingVM.dataSource[2][0];
            item.obj = totalString;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.baseTableView reloadData];
            });
        }
    }];
}

@end
