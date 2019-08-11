//
//  GGAddAddressViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGAddAddressViewController.h"
#import "GGAddressViewModel.h"
#import "GGTitleValueCell.h"
#import "GGInputAddressCell.h"
#import "GGAddressPageRoute.h"
#import "GGProvince.h"


@interface GGAddAddressViewController ()

@property(nonatomic,strong)GGAddressViewModel *addressVM;

@end

@implementation GGAddAddressViewController
{
    NSDictionary *_identifiers;
}

- (void)bindViewModel{

    @weakify(self);
    [RACObserve(self.addressVM, dataSource)subscribeNext:^(id x) {
        @strongify(self);
        [self.baseTableView reloadData];
    }];
    
    if (self.value) {
        self.addressVM.address = [self.value modelCopy];
        if ([self.addressVM.address.cityStr containsString:self.addressVM.address.provinceStr]){
            self.addressVM.address.location = self.addressVM.address.cityStr;
        }else{
            self.addressVM.address.location = [NSString stringWithFormat:@"%@%@",self.addressVM.address.provinceStr,self.addressVM.address.cityStr];
        }
        [self.addressVM.reloadData execute:nil];
    }
}

- (void)setupView
{
    [self.baseTableView registerClass:[GGTitleValueCell class] forCellReuseIdentifier:kCellIdentifierTitleValue];
    [self.baseTableView registerClass:[GGInputAddressCell class] forCellReuseIdentifier:kCellIdentifierInputAddress];
    _identifiers = @{@(GGFormCellTypeNormal):kCellIdentifierTitleValue,
                     @(GGFormCellTypeTextView):kCellIdentifierInputAddress};

    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"保存" style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self.view endEditing:YES];
        @strongify(self);
        [MBProgressHUD showMessage:@"" toView:self.view];
        
        [[self.addressVM.updateData execute:nil]subscribeError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
        } completed:^{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"已保存" toView:self.view];
            [self bk_performBlock:^(GGAddAddressViewController *obj) {
                [obj.navigationController dismissViewControllerAnimated:YES completion:^{
                    if (self.popHandler) {
                        self.popHandler(@1);
                    }
                }];
            } afterDelay:1.1];
           
        }];
    }];
}

#pragma mark TableM
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.addressVM sectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.addressVM itemCountAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGFormItem *item = [self.addressVM itemForIndexPath:indexPath];
    GGFormBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifiers[@(item.cellType)]];
    
    if (item.cellType == GGFormCellTypeTextView) {
        GGInputAddressCell *addressCell = (GGInputAddressCell *)cell;
        [addressCell setValueChangedBlock:^(NSString *text) {
            self.addressVM.address.contactAddress = text;
        }];
    }

    [cell configItem:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:14];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGFormItem *item = [self.addressVM itemForIndexPath:indexPath];
    if (item.cellType == GGFormCellTypeTextView) {
        return 90;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GGFormItem *item = [self.addressVM itemForIndexPath:indexPath];
    
    [GGAddressPageRoute pushWithItem:item nav:self.navigationController callBack:^(id x) {
         [self.addressVM.reloadData execute:x];
    }];
}

- (GGAddressViewModel *)addressVM
{
    if (!_addressVM) {
        _addressVM = [[GGAddressViewModel alloc] init];
    }
    return _addressVM;
}

@end
