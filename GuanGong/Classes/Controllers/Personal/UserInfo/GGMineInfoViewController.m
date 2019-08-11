//
//  GGMineInfoViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/5/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMineInfoViewController.h"
#import "GGHeaderImageCell.h"
#import "GGMineQrCodeCell.h"
#import "GGTitleValueCell.h"
#import "GGPersonalPageRoute.h"
#import "Helper.h"
#import "GGUserInfoViewModel.h"

@interface GGMineInfoViewController ()

@property(nonatomic,strong)GGUserInfoViewModel *userInfoVM;

@end

@implementation GGMineInfoViewController
{
    NSDictionary *_identifiers;
}

- (GGUserInfoViewModel *)userInfoVM{
    if (!_userInfoVM) {
        _userInfoVM = [[GGUserInfoViewModel alloc] init];
    }
    return _userInfoVM;
}

- (void)setupView
{
    self.navigationItem.title = @"个人信息";
    self.style = UITableViewStylePlain;
    [self.baseTableView registerClass:[GGHeaderImageCell class] forCellReuseIdentifier:kCellIdentifierHeaderImage];
    [self.baseTableView registerClass:[GGTitleValueCell class] forCellReuseIdentifier:kCellIdentifierTitleValue];
    [self.baseTableView registerClass:[GGMineQrCodeCell class] forCellReuseIdentifier:kCellIdentifierMineQrCode];
    _identifiers = @{@(GGFormCellTypeFaceView):kCellIdentifierHeaderImage,
                     @(GGFormCellTypeNormal):kCellIdentifierTitleValue,
                     @(GGFormCellTypeQrCode):kCellIdentifierMineQrCode};
}

- (void)bindViewModel
{
    @weakify(self);
    [RACObserve(self.userInfoVM, dataSource)subscribeNext:^(id x) {
        @strongify(self);
        [self.baseTableView reloadData];
    }];
}

#pragma mark TableM
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.userInfoVM sectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.userInfoVM itemCountAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGFormItem *item = [self.userInfoVM itemForIndexPath:indexPath];
    GGFormBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifiers[@(item.cellType)]];
    [cell configItem:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01f;
    }
    return 15;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kLeftPadding];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGFormItem *item = [self.userInfoVM itemForIndexPath:indexPath];
    if (item.cellType == GGFormCellTypeFaceView) {
        return 70;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    @weakify(self);
    GGFormItem *item = [self.userInfoVM itemForIndexPath:indexPath];
    
    if (item.pageType == GGPageTypeImagePicker) {
        [GGPersonalPageRoute ShowActionSheet:item
                                           formViewController:self
                                                     callBack:^(id x) {
                                                         @strongify(self);
                                                         [self.userInfoVM.editCommand execute:x];
                                                     }];
        [MobClick event:@"headportrait"];
    }else{
        [GGPersonalPageRoute pushWithItem:item nav:self.navigationController callBack:^(id result) {
            @strongify(self);
            if ([result isKindOfClass:[GGFormItem class]]) {
                [self.userInfoVM.editCommand execute:result];
            } else {
                if (item.pageType == GGPageTypeRealCompanyAuth) {
                    [self tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                }
            }
        }];
    }
}

@end
