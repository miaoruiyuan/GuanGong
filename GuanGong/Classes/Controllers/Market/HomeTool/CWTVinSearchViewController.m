//
//  CWTVinSearchViewController.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/16.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTVinSearchViewController.h"
#import "CWTVinResultViewController.h"
#import "CWTVinHistoryViewController.h"
#import "CWTVinView.h"
#import "CWTScanVinCodeView.h"
#import "CWTSearchVinViewModel.h"
#import "GGCarHistorySearvicePriceListController.h"
#import "GGAddBankCardRewardAlertView.h"
#import "GGAddCardViewController.h"
#import "GGCarHistroyDetailWebController.h"
#import "GGCarHistoryActivityViewModel.h"
#import "GGVinInfoViewModel.h"

@interface CWTVinSearchViewController ()

@property(nonatomic,strong)CWTSearchVinViewModel *searchVinVm;
@property(nonatomic,strong)GGCarHistoryActivityViewModel *activityVM;

@property(nonatomic,strong)GGVinInfoViewModel *vinInfoVM;

@property(nonatomic,strong)CWTVinView *cardView;
@property(nonatomic,strong)UIButton *searchButton;

//@property(nonatomic,strong)UIButton *takePhotoButton;

@end

@implementation CWTVinSearchViewController

- (CWTSearchVinViewModel *)searchVinVm{
    if (!_searchVinVm) {
        _searchVinVm = [[CWTSearchVinViewModel alloc] init];
    }
    return _searchVinVm;
}

- (GGVinInfoViewModel *)vinInfoVM{
    if (!_vinInfoVM) {
        _vinInfoVM = [[GGVinInfoViewModel alloc] init];
    }
    return _vinInfoVM;
}

- (void)setupView{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = _isMaintain ? @"保养记录查询" : @"VIN查车型";
    
    [self.view addSubview:self.cardView];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(22);
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.mas_equalTo(150 + kScreenWidth / 320 * 20);
    }];
    

    [self.view addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView.mas_bottom).offset(60);
        make.left.right.equalTo(self.cardView);
        make.height.mas_equalTo(45);
    }];

    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"历史查询" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        CWTVinHistoryViewController *vc = [[CWTVinHistoryViewController alloc] init];
        vc.serviceCompany = self.searchVinVm.serviceCompany;
        vc.isMaintain = self.isMaintain;
        [self pushTo:vc];
    }];
}

- (void)bindViewModel{
    if (self.isMaintain) {
        [self bindCarHistroyVM];
    }else{
        [self bindVinInfoVM];
    }
}

- (void)bindCarHistroyVM
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    @weakify(self);
    [[self.searchVinVm.serviceListCommand execute:nil] subscribeNext:^(id x) {
        [[self.searchVinVm.carHistoryBalanceCommand execute:nil] subscribeNext:^(id x) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self getCarHistoryUserActivity];
        } error:^(NSError *error) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    } error:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    [self.cardView setInputValueBlock:^(NSString *vin) {
        @strongify(self);
        self.searchVinVm.vin = vin;
    }];
    
    [[self.cardView.buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self gotoPriceListVC];
        if (self.isMaintain) {
            [MobClick event:@"buy_carhistory"];
        }else{
            [MobClick event:@"buy_vin"];
        }
    }];
    
    RAC(self.searchButton,enabled) = [RACSignal combineLatest:@[RACObserve(self.searchVinVm, vin)] reduce:^id(NSString *value){
        return @(value.length == 17);
    }];
    
    [[RACObserve(self.searchVinVm,balance) skip:1] subscribeNext:^(NSNumber *balance) {
        @strongify(self);
        self.cardView.count = [balance integerValue];
        if (self.cardView.count > 0) {
            [self.searchButton setTitle:@"查询" forState:UIControlStateNormal];
        }else{
            [self.searchButton setTitle:@"购买查询" forState:UIControlStateNormal];
        }
    }];
    
    [[self.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [self.view endEditing:YES];
        if ([self.searchVinVm.balance integerValue] <= 0) {
            [self gotoPriceListVC];
        }else{
            [sender startQueryAnimate];
            [self buyReportRequest];
        }
    }];
}

- (void)bindVinInfoVM
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    @weakify(self);
    [[self.vinInfoVM.vinInfoBalanceCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self getVinInfoUserActivity];
    } error:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

    [self.cardView setInputValueBlock:^(NSString *vin) {
        @strongify(self);
        self.vinInfoVM.vin = vin;
    }];
    
    [[self.cardView.buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self gotoPriceListVC];
    }];
    
    RAC(self.searchButton,enabled) = [RACSignal combineLatest:@[RACObserve(self.vinInfoVM, vin)] reduce:^id(NSString *value){
        return @(value.length == 17);
    }];
    
    [[RACObserve(self.vinInfoVM,balance) skip:1] subscribeNext:^(NSNumber *balance) {
        @strongify(self);
        self.cardView.count = [balance integerValue];
        if (self.cardView.count > 0) {
            [self.searchButton setTitle:@"查询" forState:UIControlStateNormal];
        }else{
            [self.searchButton setTitle:@"购买查询" forState:UIControlStateNormal];
        }
    }];
    
    [[self.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [self.view endEditing:YES];
        if ([self.vinInfoVM.balance integerValue] <= 0) {
            [self gotoPriceListVC];
        }else{
            [sender startQueryAnimate];
            [self buyVinInfoRequest];
        }
    }];
}

- (void)getUserBalance
{
    if (self.isMaintain) {
        if (self.searchVinVm.serviceCompany) {
            [self.searchVinVm.carHistoryBalanceCommand execute:nil];
        }
    }else{
        [self.vinInfoVM.vinInfoBalanceCommand execute:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserBalance];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark - CarHistory 维修保养记录
- (void)getCarHistoryUserActivity
{
    @weakify(self);
    self.activityVM = [[GGCarHistoryActivityViewModel alloc] init];
    self.activityVM.activityId = @"2";
    [[self.activityVM.getActivityCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        GGUserActivityModel *model = self.activityVM.activityModel;
        if (model && model.activityId) {
            if (model.status == GGUserActivityStatusCanReceive){
                [GGAddBankCardRewardAlertView showAuthenticateWithContent:model.des onlyShowSubmitBtn:@"立即领取" andBlock:^(BOOL isCancel) {
                    @weakify(self);
                    [[self.activityVM.executeActivityCommand execute:@"2"] subscribeNext:^(id x) {
                        @strongify(self);
                        [self.searchVinVm.carHistoryBalanceCommand execute:nil];
                        [MBProgressHUD showSuccess:@"领取成功" toView:self.view];
                        [self getCarHistoryBankActivity];
                    }];
                }];
            }else if (model.status == GGUserActivityStatusReceived){
                [self getCarHistoryBankActivity];
            }
        }
    }];
}

- (void)getCarHistoryBankActivity
{
    @weakify(self);
    self.activityVM = [[GGCarHistoryActivityViewModel alloc] init];
    self.activityVM.activityId = @"1";
    [[self.activityVM.getActivityCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        GGUserActivityModel *model = self.activityVM.activityModel;
        if (model && model.activityId) {
            if (model.status == GGUserActivityStatusCanJoin) {
                [GGAddBankCardRewardAlertView showWithContent:model.des confirmText:@"去绑定" andBlock:^(BOOL isCancel) {
                    if (isCancel) {
                        [self.cardView becomeFirstResponder];
                    } else {
                        [self.activityVM.executeActivityCommand execute:@"1"];
                        GGAddCardViewController *addCardVC = [[GGAddCardViewController alloc] init];
                        addCardVC.popHandler = ^(id value) {
                            [self getCarHistoryUserActivity];
                        };
                        [[self class] presentVC:addCardVC];
                    }
                }];
            }else if (model.status == GGUserActivityStatusCanReceive){
                [GGAddBankCardRewardAlertView showCardWithContent:model.des onlyShowSubmitBtn:@"立即领取" andBlock:^(BOOL isCancel) {
                    @weakify(self);
                    [[self.activityVM.executeActivityCommand execute:@"2"] subscribeNext:^(id x) {
                        @strongify(self);
                        [self.searchVinVm.carHistoryBalanceCommand execute:nil];
                        [MBProgressHUD showSuccess:@"领取成功" toView:self.view];
                    }];
                }];
            }
        }
    }];
}

- (void)getVINInfoBankCardActivity
{
    @weakify(self);
    self.activityVM = [[GGCarHistoryActivityViewModel alloc] init];
    self.activityVM.activityId = @"4";
    [[self.activityVM.getActivityCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        GGUserActivityModel *model = self.activityVM.activityModel;
        if (model && model.activityId) {
            if (model && model.activityId) {
                if (model.status == GGUserActivityStatusCanJoin) {
                    [GGAddBankCardRewardAlertView showWithContent:model.des confirmText:@"去绑定" andBlock:^(BOOL isCancel) {
                        if (isCancel) {
                            [self.cardView becomeFirstResponder];
                        } else {
                            [self.activityVM.executeActivityCommand execute:@"1"];
                            GGAddCardViewController *addCardVC = [[GGAddCardViewController alloc] init];
                            addCardVC.popHandler = ^(id value) {
                                [self getVINInfoBankCardActivity];
                            };
                            [[self class] presentVC:addCardVC];
                        }
                    }];
                }else if (model.status == GGUserActivityStatusCanReceive){
                    [GGAddBankCardRewardAlertView showCardWithContent:model.des onlyShowSubmitBtn:@"立即领取" andBlock:^(BOOL isCancel) {
                        @weakify(self);
                        [[self.activityVM.executeActivityCommand execute:@"2"] subscribeNext:^(id x) {
                            @strongify(self);
                            [self.vinInfoVM.vinInfoBalanceCommand execute:nil];
                            [MBProgressHUD showSuccess:@"领取成功" toView:self.view];
                        }];
                    }];
                }
            }
        }
    }];
}

- (void)getVinInfoUserActivity
{
    @weakify(self);
    self.activityVM = [[GGCarHistoryActivityViewModel alloc] init];
    self.activityVM.activityId = @"3";
    [[self.activityVM.getActivityCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        GGUserActivityModel *model = self.activityVM.activityModel;
        if (model && model.activityId) {
            if (model.status == GGUserActivityStatusCanReceive){
                [GGAddBankCardRewardAlertView showAuthenticateWithContent:model.des onlyShowSubmitBtn:@"立即领取" andBlock:^(BOOL isCancel) {
                    @weakify(self);
                    [[self.activityVM.executeActivityCommand execute:@"2"] subscribeNext:^(id x) {
                        @strongify(self);
                        [self.vinInfoVM.vinInfoBalanceCommand execute:nil];
                        [MBProgressHUD showSuccess:@"领取成功" toView:self.view];
                        [self getVINInfoBankCardActivity];
                    }];
                }];
            }else if (model.status == GGUserActivityStatusReceived){
                [self getVINInfoBankCardActivity];
            }
        }
    }];
}

- (void)buyReportRequest
{
    @weakify(self);
    [[self.searchVinVm.buyCarHistoryCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        GGCarHistroyDetailWebController *detailViewVC = [[GGCarHistroyDetailWebController alloc] initWithDetailModel:self.searchVinVm.reportDetailModel];
        [self pushTo:detailViewVC];
        [self.searchButton stopQueryAnimate];
        [self.searchVinVm.carHistoryBalanceCommand execute:nil];
        [self.cardView clearInputText];
    } error:^(NSError *error) {
        @strongify(self);
        [self.searchButton stopQueryAnimate];
        [self.searchVinVm.carHistoryBalanceCommand execute:nil];
    }];
}

- (void)buyVinInfoRequest
{
    @weakify(self);
    [[self.vinInfoVM.vinGetDiffModelsCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        CWTVinResultViewController *vc = [[CWTVinResultViewController alloc] init];
        vc.value = self.vinInfoVM.vinResults;
        vc.vinInfoVM = self.vinInfoVM;
        [vc setPopHandler:^(id value){
            GGWebViewController *webVC = [[GGWebViewController alloc] init];
            webVC.url = self.vinInfoVM.vinInfoDetail.detailUrl;
            webVC.navigationItem.title = @"VIN查询结果";
            [self pushTo:webVC];
        }];
        [[self class] presentVC:vc];
        [self.searchButton stopQueryAnimate];
        [self.vinInfoVM.vinInfoBalanceCommand execute:nil];
//        [self.cardView clearInputText];
    } error:^(NSError *error) {
        @strongify(self);
        [self.searchButton stopQueryAnimate];
        [self.vinInfoVM.vinInfoBalanceCommand execute:nil];
    }];
}

- (void)gotoPriceListVC
{
    if (self.isMaintain) {
        GGCarHistorySearvicePriceListController *priceListVC = [[GGCarHistorySearvicePriceListController alloc] initWithSearchVinVM:self.searchVinVm];
        [self pushTo:priceListVC];
    }else{
        GGCarHistorySearvicePriceListController *priceListVC = [[GGCarHistorySearvicePriceListController alloc] initWithVinInfoVM:self.vinInfoVM];
        [self pushTo:priceListVC];
    }
}

#pragma mark -  init View

- (CWTVinView *)cardView{
    if (!_cardView) {
        _cardView = [[CWTVinView alloc] init];
        _cardView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        _cardView.layer.masksToBounds = YES;
        _cardView.layer.cornerRadius = 10;
        _cardView.layer.borderColor = [UIColor colorWithHexString:@"d7d7d7"].CGColor;
        _cardView.layer.borderWidth = 0.5f;
    }
    return _cardView;
}

- (UIButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setTitle:@"查询" forState:UIControlStateNormal];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_searchButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"c5c5c5"]] forState:UIControlStateDisabled];
        [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_searchButton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        _searchButton.layer.masksToBounds = YES;
        _searchButton.layer.cornerRadius = 2;
    }
    return _searchButton;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
