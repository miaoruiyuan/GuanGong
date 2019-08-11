//
//  GGConfirmPayPasswordViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGConfirmPayPasswordViewController.h"
#import "GGPaymentSetViewController.h"
#import "GGPasscodeView.h"
#import "GGSetPasswordViewModel.h"
#import "GGFooterView.h"
#import "GGCheckCardIDViewController.h"
#import "GGTransferViewController.h"

@interface GGConfirmPayPasswordViewController ()

@property(nonatomic,strong)GGSetPasswordViewModel *setPayVM;

@property(nonatomic,strong)GGPasscodeView *codeView1;
@property(nonatomic,strong)GGPasscodeView *codeView2;
@property(nonatomic,strong)UILabel *label1;
@property(nonatomic,strong)UILabel *label2;

@property(nonatomic,strong)GGFooterView *footerView;


@end

@implementation GGConfirmPayPasswordViewController


- (id)initWithiCode:(NSString *)code{
    if (self = [super init]) {
        self.setPayVM.iCode = code;
    }
    return self;
}

- (GGSetPasswordViewModel *)setPayVM{
    if (!_setPayVM) {
        _setPayVM = [[GGSetPasswordViewModel alloc] init];
    }
    return _setPayVM;
}

- (void)bindViewModel{
    RAC(self.footerView.footerButton,enabled) = self.setPayVM.enabelSignal;
}


- (void)setupView{
    self.navigationItem.title = @"确认支付密码";
    
    [self.view addSubview:self.codeView1];
    [self.view addSubview:self.codeView2];
    
    [self.view addSubview:self.label1];
    [self.view addSubview:self.label2];
    [self.view addSubview:self.footerView];
    
    [self.codeView1 beginEdit];
    
    @weakify(self);
    self.codeView1.EndEditBlcok = ^(NSString *text,GGPasscodeView *view){
        @strongify(self);
        self.setPayVM.password1 = text;
        [self.codeView2 beginEdit];
    };
    
    
    self.codeView2.EndEditBlcok = ^(NSString *text,GGPasscodeView *view){
        @strongify(self);
        self.setPayVM.password2 = text;
        if (![self.setPayVM.password1 isEqualToString:self.setPayVM.password2]) {
            [MBProgressHUD showError:@"两次密码输入不一致" toView:self.view];
        }
    
    };
    
    [[self.footerView.footerButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
        @strongify(self);
        [self.codeView2 endEdit];
        [self.codeView1 endEdit];
        
        [MBProgressHUD showMessage:@"请稍后" toView:self.view];
        [[self.setPayVM.setPayPasswordCommand execute:nil] subscribeError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
        } completed:^{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"设置成功" toView:self.view];
            [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:GGPaymentPassword];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self bk_performBlock:^(GGConfirmPayPasswordViewController *obj) {
                [obj dismiss];
            } afterDelay:1.2];
        }];
    }];
}

- (GGPasscodeView *)codeView1{
    if (!_codeView1) {
        _codeView1 = [[GGPasscodeView alloc] initWithFrame:CGRectMake(20, 80, self.view.width - 40, 40) num:6 lineColor:sectionColor textFont:28];
        _codeView1.codeType = CodeViewTypeSecret;
        _codeView1.hasSpaceLine = YES;
    }
    return _codeView1;
}

- (UILabel *)label1{
    if (!_label1) {
        _label1 = [[UILabel alloc] initWithFrame:CGRectMake(self.codeView1.left, self.codeView1.bottom + 6, 140, 14)];
        _label1.text = @"请设置新支付密码";
        _label1.font = [UIFont systemFontOfSize:12];
        _label1.textColor = textNormalColor;
    }
    return _label1;
}

- (GGPasscodeView *)codeView2{
    if (!_codeView2) {
        _codeView2 = [[GGPasscodeView alloc] initWithFrame:CGRectMake(20, self.label1.bottom + 24, self.view.width - 40, 40) num:6 lineColor:sectionColor textFont:28];
        _codeView2.codeType = CodeViewTypeSecret;
        _codeView2.hasSpaceLine = YES;
    }
    return _codeView2;
}

- (UILabel *)label2{
    if (!_label2) {
        _label2 = [[UILabel alloc] initWithFrame:CGRectMake(self.codeView2.left, self.codeView2.bottom + 6, 140, 14)];
        _label2.text = @"请确认支付密码";
        _label2.font = [UIFont systemFontOfSize:12];
        _label2.textColor = textNormalColor;
    }
    return _label2;
}

- (GGFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[GGFooterView alloc] initWithFrame:CGRectMake(20, self.label2.bottom + 30, self.view.width - 40, 52) andFootButtonTitle:@"确认"];
    }
    return _footerView;
}

@end
