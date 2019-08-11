//
//  GGPaymentSetViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPaymentSetViewController.h"
#import "GGCheckCardIDViewController.h"
#import "GGRevisePasswordViewController.h"
#import "GGSetPayPasswordViewController.h"

#import "GGTableViewCell.h"

@interface GGPaymentSetViewController ()

@end

@implementation GGPaymentSetViewController

- (void)bindViewModel{
    

}

- (void)setupView{
    self.navigationItem.title = @"支付设置";
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
    
    return [GGLogin shareUser].haveSetPayPassword ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = [GGLogin shareUser].haveSetPayPassword ? @"忘记支付密码" : @"设置支付密码";
            break;
            
        default:
            cell.titleLabel.text = @"修改支付密码";
            break;
    }
    
    return cell;
}


#pragma mark - Table
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:20];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        if ([GGLogin shareUser].haveSetPayPassword) {
            GGCheckCardIDViewController *payVC = [[GGCheckCardIDViewController alloc]init];
            [[self class] presentVC:payVC];
        }else{
            GGSetPayPasswordViewController *setPWDVC = [[GGSetPayPasswordViewController alloc]init];
            [[self class] presentVC:setPWDVC];
        }
    }else{
        GGRevisePasswordViewController *reviseVC = [[GGRevisePasswordViewController alloc]init];
        reviseVC.isSetPaymentPassword = YES;
        [self pushTo:reviseVC];
    }
    
}


@end
