//
//  GGRechargeViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/20.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGRechargeViewController.h"
#import "GGCapitalClearListViewController.h"
#import "GGCapitalClearApplyViewController.h"
#import "GGWebViewController.h"
#import "GGPingAnBankInfoCell.h"
#import "UILabel+Common.h"

@interface GGRechargeViewController ()

@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIView *cardView;

@end

@implementation GGRechargeViewController

- (void)bindViewModel
{
    
}

- (void)setupView{
    self.navigationItem.title = @"充值";
    
    self.style = UITableViewStylePlain;
    self.baseTableView.tableHeaderView = self.headerView;
    self.baseTableView.rowHeight = UITableViewAutomaticDimension;
    self.baseTableView.estimatedRowHeight = 60;
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idntifeir = @"GGPingAnBankInfoCell";
    GGPingAnBankInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:idntifeir];
    if (!cell) {
        cell = [[GGPingAnBankInfoCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:idntifeir];
    }

    switch (indexPath.row) {
        case 0:
            [cell showTitle:@"网银充值" content:@"1、登录网上银行或手机银行；\n2、选择转账汇款业务；\n3、输入汇款信息；\n4、确认汇款信息并支付；\n5、转账完成充值成功；"];
            break;
        case 1:
            [cell showTitle:@"柜台充值" content:@"1、向工作人员说明办理转账汇款业务；\n2、在工作人员指导下填写转账单；\n3、转账完成充值成功"];
            break;
        default:
            [cell showTitle:@"ATM充值" content:@"1、插入银行卡，按提示输入密码；\n2、点击更多业务；\n3、选择转账汇款业务；\n4、选择跨行转账汇款；\n5、选择人行跨行转账；\n6、输入收款人帐号及收款人姓名（收款人帐号：11015043211000 收款人姓名：北京阳光第一车网科技有限公司）；\n7、确认汇款信息；\n8、转账成功充值成功；"];
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - init view

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 244)];
        _headerView.backgroundColor  = [UIColor whiteColor];
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.text = @"请用已绑定的银行卡对此平安银行账号进行转账已完成充值";
        tipLabel.numberOfLines = 0;
        tipLabel.preferredMaxLayoutWidth = kScreenWidth - 24;
        tipLabel.font = [UIFont systemFontOfSize:13];
        tipLabel.textColor = [UIColor colorWithHexString:@"8e8e8e"];
        
        [_headerView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView).offset(15);
            make.left.equalTo(_headerView).offset(12);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = sectionColor;
        [_headerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_headerView);
            make.height.mas_equalTo(0.5f);
            make.bottom.equalTo(_headerView).offset(-12);
        }];
        
        [_headerView addSubview:self.cardView];
        [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(12);
            make.right.equalTo(_headerView).offset(-12);
            make.top.equalTo(tipLabel.mas_bottom).offset(15);
            make.bottom.equalTo(lineView.mas_top).offset(-25);
        }];
    }
    return _headerView;
}

- (UIView *)cardView
{
    if (!_cardView) {
        
        _cardView = [[UIView alloc] init];
    
        _cardView.layer.masksToBounds = YES;
        _cardView.layer.cornerRadius = 4;
        _cardView.layer.borderColor = sectionColor.CGColor;
    
        _cardView.layer.borderWidth = 0.5f;
    
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"北京阳光第一车网科技有限公司";
        nameLabel.copyingEnabled = YES;

        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.textColor = [UIColor colorWithHexString:@"000000"];
        
        [_cardView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cardView).offset(25);
            make.left.equalTo(_cardView).offset(25);
        }];
        
        UILabel *cardIDLabel = [[UILabel alloc] init];
        cardIDLabel.text = @"11015043211000";
        cardIDLabel.copyingEnabled = YES;

        cardIDLabel.font = [UIFont boldSystemFontOfSize:24];
        cardIDLabel.textColor = [UIColor colorWithHexString:@"000000"];
        
        [_cardView addSubview:cardIDLabel];
        [cardIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(8);
            make.left.equalTo(nameLabel);
        }];
        
        UILabel *addressLabel = [[UILabel alloc] init];
        addressLabel.copyingEnabled = YES;
        addressLabel.text = @"平安银行北京东三环支行";
        addressLabel.textAlignment = NSTextAlignmentRight;
        addressLabel.font = [UIFont systemFontOfSize:12];
        addressLabel.textColor = [UIColor colorWithHexString:@"737373"];
        
        [_cardView addSubview:addressLabel];
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_cardView).offset(-25);
            make.right.equalTo(_cardView).offset(-25);
        }];
    
    }
    return _cardView;
}

- (void)dealloc{

}

@end
