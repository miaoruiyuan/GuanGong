
//
//  GGRewardViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/16.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGRewardViewController.h"
#import "GGSetPayPasswordViewController.h"
#import "GGRewardViewModel.h"
#import "FDStackView.h"

#import "GGPaymentCodeView.h"

@interface GGRewardViewController ()<GGPaymentCodeDelegate>

@property(nonatomic,strong)UIImageView *rewardLogo;
@property(nonatomic,strong)UILabel *rewardLabel;
@property(nonatomic,strong)FDStackView *stackView;
@property(nonatomic,strong)FDStackView *stackView2;
@property(nonatomic,strong)NSMutableArray *buttonArray;
@property(nonatomic,strong)UITextField *otherTextField;

@property(nonatomic,strong)UIButton *rewardButton;

@property(nonatomic,strong)GGPaymentCodeView *codeView;

@property(nonatomic,strong)GGRewardViewModel *rewardVM;


@end

@implementation GGRewardViewController{
    UIButton *lastButton;
}

- (void)bindViewModel{
    self.rewardVM.orderNo = self.orderNo;
    
    
    [self.rewardVM.rewardInfoCommond execute:nil];
    [[self.rewardVM.rewardInfoCommond.executing skip:1]subscribeNext:^(NSNumber *x) {
        if ([x isEqualToNumber:@YES]) {
            [MBProgressHUD showMessage:@"" toView:self.view];
        }else{
            [MBProgressHUD hideHUDForView:self.view];
        }
        
    }];
    
    @weakify(self);
    [[RACObserve(self.rewardVM, rewardInfo)skip:1]subscribeNext:^(RewardInfo *x) {
       
        @strongify(self);
        for (int i = 0 ; i < x.amts.count; i ++ ) {

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i + 80;
            [button setTitle:[NSString stringWithFormat:@"%@元",x.amts[i]] forState:UIControlStateNormal];
            [button setTitleColor:themeColor forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [button setBackgroundImage:[UIImage imageNamed:@"rewardPrice_unselected"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"rewardPrice_selected"] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:@"rewardPrice_selected"] forState:UIControlStateHighlighted];
            
            
            [[button rac_signalForControlEvents:UIControlEventTouchDown]subscribeNext:^(UIButton *btn) {
                [self.view endEditing:YES];
                if (btn != lastButton) {
                    lastButton.selected = NO;
                    lastButton = button;
                }
                lastButton.selected = YES;
                
                self.rewardVM.tranAmount = x.amts[btn.tag - 80];
            }];
            
            [self.buttonArray addObject:button];
        }
        
        [self.view addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rewardLabel.mas_bottom).offset(50);
            make.left.equalTo(self.view.mas_left).with.offset(10);
            make.right.equalTo(self.view.mas_right).with.offset(-10);
            make.height.mas_equalTo(45);
        }];
        
        [self.view addSubview:self.stackView2];
        [self.stackView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stackView.mas_bottom).offset(10);
            make.left.right.equalTo(self.stackView);
            make.height.mas_equalTo(45);
        }];
        

        @weakify(self);
        self.otherTextField.bk_didBeginEditingBlock = ^(UITextField *field){
            @strongify(self);
            for (UIButton *button in self.stackView.arrangedSubviews) {
                button.selected = NO;
            }
            for (UIButton *button in self.stackView2.arrangedSubviews) {
                button.selected = NO;
            }
        };
        
        
        
        [self.view addSubview:self.rewardButton];
        [self.rewardButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stackView2.mas_bottom).offset(20);
            make.left.equalTo(self.view.mas_left).with.offset(10);
            make.right.equalTo(self.view.mas_right).with.offset(-10);
            make.height.mas_equalTo(44);
        }];

    }];

    
    RAC(self.rewardButton,enabled) = self.rewardVM.enbleRewardSignal;
    
    
    //输入金额
    RAC(self.rewardVM,tranAmount) = self.otherTextField.rac_textSignal;
    
    
    [RACObserve(self.rewardVM, tranAmount)subscribeNext:^(NSString *x) {
        @strongify(self);
        [self.rewardButton setTitle:[NSString stringWithFormat:@"打赏%@",x.length > 0 ? x: @""] forState:UIControlStateNormal];
    }];
    
    
    

}

- (void)setupView{
    self.navigationItem.title = @"打赏";
    
    [self.view addSubview:self.rewardLogo];
    [self.rewardLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(89);
        make.size.mas_equalTo(CGSizeMake(185, 136));
        make.centerX.equalTo(self.view);
    }];
    
    
    [self.view addSubview:self.rewardLabel];
    [self.rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rewardLogo.mas_bottom).offset(15);
        make.centerX.equalTo(self.rewardLogo);
        make.height.mas_equalTo(16);
    }];
    
    
    
    @weakify(self);
    [[self.rewardButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
        
        //判断是否设置了支付密码
        if (![GGLogin shareUser].haveSetPayPassword) {
            [UIAlertController alertInController:self
                                           title:@"使用此功能之前需要设置支付密码哦"
                                         message:nil
                                      confrimBtn:@"去设置"
                                    confrimStyle:UIAlertActionStyleDefault
                                   confrimAction:^{
                                       GGSetPayPasswordViewController *setPVC = [[GGSetPayPasswordViewController alloc] init];
                                       [GGRewardViewController presentVC:setPVC];
                                   }
                                       cancelBtn:@"取消"
                                     cancelStyle:UIAlertActionStyleCancel
                                    cancelAction:^{}];
            
        }else{
           [self.codeView show];
        }
    }];
    

    
}



- (void)didTappedConfirmButtonWithpaymentPassword:(NSString *)paymentPassword{
    
    [self.codeView dismiss];
    [MBProgressHUD showMessage:@"请稍后" toView:self.view];
    [[self.rewardVM.rewardCommond execute:paymentPassword]subscribeError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    } completed:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showSuccess:@"打赏成功" toView:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:GGRefreshBuyerListNotification object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:GGRefreshSellerListNotification object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:GGTransferSuccessNotification object:nil];
        [self bk_performBlock:^(GGRewardViewController *obj) {
            [obj dismiss];
        } afterDelay:1.1];
    }];
    
    
}
- (void)didTappedColseButton{}

- (void)didTappedForgetPasswordButton{
    GGSetPayPasswordViewController *setPayPassVC = [[GGSetPayPasswordViewController alloc] init];
    [[self class] presentVC:setPayPassVC];
}

- (void)paymentComplete{}

- (UIImageView *)rewardLogo{
    if (!_rewardLogo) {
        _rewardLogo = [[UIImageView alloc]init];
        _rewardLogo.image = [UIImage imageNamed:@"reward_logo"];
    }
    return _rewardLogo;
}

- (UILabel *)rewardLabel{
    if (!_rewardLabel) {
        _rewardLabel = [[UILabel alloc] init];
        _rewardLabel.text = @"打赏一下 支持关二爷";
        _rewardLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _rewardLabel.textColor = [UIColor colorWithHexString:@"000000"];
    }
    return _rewardLabel;
}

- (FDStackView *)stackView{
    if (!_stackView) {
        _stackView = [[FDStackView alloc] initWithArrangedSubviews:[self.buttonArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]]];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.spacing = 10;
    }
    return _stackView;
}

- (FDStackView *)stackView2{
    if (!_stackView2) {
        _stackView2 = [[FDStackView alloc] initWithArrangedSubviews:[self.buttonArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 2)]]];
        [_stackView2 addArrangedSubview:self.otherTextField];
        _stackView2.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView2.axis = UILayoutConstraintAxisHorizontal;
        _stackView2.distribution = UIStackViewDistributionFillEqually;
        _stackView2.alignment = UIStackViewAlignmentFill;
        _stackView2.spacing = 10;
    }
    return _stackView2;
}


- (UIButton *)rewardButton{
    if (!_rewardButton) {
        _rewardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rewardButton setTitle:@"打赏" forState:UIControlStateNormal];
        _rewardButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [_rewardButton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        _rewardButton.layer.masksToBounds = YES;
        _rewardButton.layer.cornerRadius = 6;
        
    }
    return _rewardButton;
}

- (UITextField *)otherTextField{
    if (!_otherTextField) {
        _otherTextField = [[UITextField alloc] init];
        _otherTextField.placeholder = @"其它金额";
        _otherTextField.font = [UIFont systemFontOfSize:16];
        _otherTextField.background = [UIImage imageNamed:@"rewardPrice_unselected"];
        _otherTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _otherTextField.textAlignment = NSTextAlignmentCenter;
        _otherTextField.textColor = themeColor;
        _otherTextField.tintColor = themeColor;
    }
    return _otherTextField;
}

- (GGPaymentCodeView *)codeView{
    if (!_codeView) {
        _codeView = [[GGPaymentCodeView alloc]init];
        _codeView.delegate = self;
    }
    return _codeView;
}

- (GGRewardViewModel *)rewardVM{
    if (!_rewardVM) {
        _rewardVM = [[GGRewardViewModel alloc] init];
    }
    return _rewardVM;
}


- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}

@end
