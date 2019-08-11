//
//  GGCarHistroyDetailWebController.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/17.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGCarHistroyDetailWebController.h"
#import "CWTSearchVinViewModel.h"
#import "GGCarHistorySearvicePriceListController.h"
#import "CWTVinHistoryViewModel.h"

@interface GGCarHistroyDetailWebController ()

@property (nonatomic,strong)GGCarHistoryReportDetailModel *detailModel;
@property (nonatomic,strong)UIButton *buyBtn;
@property (nonatomic,strong)CWTSearchVinViewModel *searchVinVM;
@property (nonatomic,strong)CWTVinHistoryViewModel *vinHistoryVM;

@end

@implementation GGCarHistroyDetailWebController

- (instancetype)initWithDetailModel:(GGCarHistoryReportDetailModel *)detailModel
{
    self = [super init];
    if (self) {
        _detailModel = detailModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CWTVinHistoryViewModel *)vinHistoryVM
{
    if (!_vinHistoryVM) {
        _vinHistoryVM = [[CWTVinHistoryViewModel alloc] init];
    }
    return _vinHistoryVM;
}

- (void)bindViewModel
{
    @weakify(self);
    
    self.searchVinVM = [[CWTSearchVinViewModel alloc] init];
    
    [[self.searchVinVM.serviceListCommand execute:nil] subscribeNext:^(id x) {
        [[self.searchVinVM.carHistoryBalanceCommand execute:nil] subscribeNext:^(id x) {
        } error:^(NSError *error) {
        }];
    } error:^(NSError *error) {
        
    }];
    
    [RACObserve(self, url) subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD showMessage:@"请稍后" toView:self.view];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }];
}

- (void)setupView
{
    self.navigationItem.title = @"保养记录查询结果";
    [self.view addSubview:self.webView];
    [self showDetail];
}

- (void)showDetail
{
    self.url = self.detailModel.reportUrl;
    if ([self.detailModel.reportStatus isEqualToNumber:@4]) {
        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-45);
        }];
        [self.view addSubview:self.buyBtn];
        [self.buyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(45);
        }];
    } else {
        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        if (_buyBtn) {
            self.buyBtn.hidden = YES;
            [self.buyBtn removeFromSuperview];
        }
    }
    
    if ([self.detailModel.reportStatus isEqualToNumber:@1]) {
        @weakify(self);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"刷新" style:UIBarButtonItemStylePlain handler:^(id sender) {
            @strongify(self);
            [[[self.vinHistoryVM carHistoryDetailCommand] execute:[self.detailModel.reportId stringValue]] subscribeNext:^(id x) {
                self.detailModel = self.vinHistoryVM.reportDetailModel;
                [self showDetail];
            }];
        }];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)buyReportRequest
{
    [[self.searchVinVM.buyCarHistoryCommand execute:nil] subscribeNext:^(id x) {
        self.detailModel = self.searchVinVM.reportDetailModel;
        [self showDetail];
        [self.buyBtn stopQueryAnimate];
        [self.searchVinVM.carHistoryBalanceCommand execute:nil];
    } error:^(NSError *error) {
        [self.buyBtn stopQueryAnimate];
        [self.searchVinVM.carHistoryBalanceCommand execute:nil];
    }];
}

- (void)bindBtnAction
{
    [[self.buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender){
        if (self.searchVinVM.balance) {
            NSInteger count = [self.searchVinVM.balance integerValue];
            if (count == 0) {
                GGCarHistorySearvicePriceListController *listVC = [[GGCarHistorySearvicePriceListController alloc] initWithSearchVinVM:self.searchVinVM];
                [self pushTo:listVC];
            }else{
                NSString *message = [NSString stringWithFormat:@"当前可用次数%ld,查询成功后,剩余次数%ld",count,count - 1];
                [UIAlertController alertInController:self title:@"确定查询？" message:message confrimBtn:@"查询" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
                    self.searchVinVM.vin = self.detailModel.vin;
                    [self buyReportRequest];
                } cancelBtn:@"取消" cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
            }
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIButton *)buyBtn
{
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setTitle:@"查询最新记录" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyBtn setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self bindBtnAction];
    }
    return _buyBtn;
}

@end
