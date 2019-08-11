
//
//  GGFingerMarkViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/24.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFingerMarkViewController.h"
#import "GGSwichCell.h"

@interface GGFingerMarkViewController ()

@property(nonatomic,strong)NSNumber *fingerPay;

@end

@implementation GGFingerMarkViewController

- (void)setupView{
    self.navigationItem.title = @"指纹";
    [self.baseTableView registerClass:[GGSwichCell class] forCellReuseIdentifier:kCellIdentifierSwich];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)bindViewModel{
    
    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:GGFingerPay];
    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"fingerLock"];
    
    
    self.fingerPay = [[NSUserDefaults standardUserDefaults] objectForKey:GGFingerPay];
    
}


#pragma mark TableM
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGSwichCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierSwich];
    
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"指纹解锁";
            [[[cell.swich rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(id x) {
                
                
                
            }];
            break;
            
        default:
            cell.titleLabel.text = @"指纹支付";
            [cell.swich setOn:self.fingerPay.boolValue animated:YES];
            
            [[[cell.swich rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(UISwitch *x) {
                
                if (x.isOn) {
                    
                }else{
                    DLog(@"关了,开了");
                }
                
            }];
            break;
    }
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"开启后,可使用Touch ID验证指纹快速完成解锁或付款";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:20];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}





@end
