//
//  GGTransferSuccessfulViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/3/4.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGTransferSuccessfulViewController.h"
#import "TTTAttributedLabel.h"
#import "GGTransferEnterViewController.h"
#import "CWTVinSearchViewController.h"

@interface GGTransferSuccessfulViewController ()

@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)TTTAttributedLabel *moneyLabel;
@property (nonatomic,strong)UIButton *doneBtn;

@end

@implementation GGTransferSuccessfulViewController


- (void)setupView
{
    self.navigationItem.title = @"转账详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.hidesBackButton = YES;
    [self.view addSubview:self.iconImageView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(110);
    }];

    [self.view addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(145);
    }];

    [self.view addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(180);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = sectionColor;
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(37);
        make.right.equalTo(self.view).offset(-37);
        make.top.equalTo(self.view).offset(256);
        make.height.mas_equalTo(0.5);
    }];

    [self.view addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(37);
        make.right.equalTo(self.view).offset(-37);
        make.top.equalTo(self.view).offset(310);
        make.height.mas_equalTo(45);
    }];
    
    [self updateUI];
}

- (void)updateUI
{
    [[self.doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.popHandler) {
            self.popHandler(nil);
            return;
        }
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[GGTransferEnterViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];

    self.titleLabel.text = @"支付成功";
    self.messageLabel.text = [NSString stringWithFormat:@"%@已成功收到您的转账",self.accountVM.account.realName];
    
    NSString *priceStr = [NSString stringWithFormat:@"￥%@",[NSString positiveFormat:self.accountVM.trade.tranAmount]];
    [self.moneyLabel setText:[NSString stringWithFormat:@"%@元",priceStr] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange markRange = [[mutableAttributedString string] rangeOfString:@"元" options:NSCaseInsensitiveSearch];
        [mutableAttributedString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} range:markRange];
        return mutableAttributedString;
    }];
}

#pragma mark - init view

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_TransferSuccessful"]];
    }
    
    return _iconImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}


- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor colorWithHexString:@"8e8e8e"];
    }
    return _messageLabel;
}


- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 180, kScreenWidth, 40)];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:30];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.textColor = [UIColor blackColor];
    }
    return _moneyLabel;
}

- (UIButton *)doneBtn
{
    if(!_doneBtn){
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        [_doneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _doneBtn.layer.masksToBounds = YES;
        _doneBtn.layer.cornerRadius = 4;
    }
    return _doneBtn;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
