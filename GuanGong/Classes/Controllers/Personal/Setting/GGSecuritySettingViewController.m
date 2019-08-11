//
//  GGSecuritySettingViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/16.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGSecuritySettingViewController.h"
#import "GGRevisePasswordViewController.h"
#import "GGPaymentSetViewController.h"
#import "GGFingerMarkViewController.h"
#import "GGTableViewCell.h"

@interface GGSecuritySettingViewController ()

@end

@implementation GGSecuritySettingViewController

- (void)setupView
{
    self.navigationItem.title = @"安全设置";
    [self.baseTableView registerClass:[GGTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

#pragma mark TableM
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"登录密码";
            break;
            
        case 1:
            cell.titleLabel.text = @"支付密码";
            break;
            
        default:
            cell.titleLabel.text = @"指纹";
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
        GGRevisePasswordViewController *reviseVC = [[GGRevisePasswordViewController alloc]init];
        reviseVC.isSetPaymentPassword = NO;
        [self pushTo:reviseVC];

    }else if (indexPath.row == 1){
        GGPaymentSetViewController *paySetVC = [[GGPaymentSetViewController alloc]init];
        [self pushTo:paySetVC];
    }else{
        GGFingerMarkViewController *fingerVC = [[GGFingerMarkViewController alloc] init];
        [self pushTo:fingerVC];
    }

}






@end
