//
//  GGChangePhoneViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/7/18.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGChangePhoneViewController.h"
#import "GGTableViewCell.h"

#import "GGCheckCardIDViewController.h"
#import "GGBingNewPhoneViewController.h"

@interface GGChangePhoneViewController ()

@end

@implementation GGChangePhoneViewController

- (void)setupView
{
    self.navigationItem.title = @"更换绑定手机";
    [self.baseTableView registerClass:[GGTableViewCell class] forCellReuseIdentifier:@"GGTableViewCell"];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark TableM
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([GGLogin shareUser].user.auditingType == AuditingTypePass) {
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGTableViewCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"原手机号可接收验证码";
            break;

        default:
            cell.titleLabel.text = @"原手机号不能接收验证码";
            break;
    }
    
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:20];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if ([GGLogin shareUser].user.auditingType == AuditingTypePass) {
            GGCheckCardIDViewController *cardIDVC = [[GGCheckCardIDViewController alloc] init];
            cardIDVC.isChangePhone = YES;
            [[self class] presentVC:cardIDVC];
        }else{
            GGBingNewPhoneViewController *phoneVC = [[GGBingNewPhoneViewController alloc] init];
            [[self class] presentVC:phoneVC];
        }
    }else if (indexPath.row == 1){
        GGCheckCardIDViewController *cardIDVC = [[GGCheckCardIDViewController alloc] init];
        cardIDVC.isChangePhone = YES;
        cardIDVC.checkBankCard = YES;
        [[self class] presentVC:cardIDVC];
    }
}

@end
