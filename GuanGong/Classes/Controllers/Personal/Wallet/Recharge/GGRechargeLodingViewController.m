//
//  GGRechargeLodingViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/7/24.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGRechargeLodingViewController.h"
#import "GGApiManager+Recharge.h"
#import "GGRechargeErrorViewController.h"

@interface GGRechargeLodingViewController ()

@property (nonatomic,strong) NSString *orderNo;

@property (nonatomic,strong) UIImageView *tipImageView;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,assign) NSInteger requestTime;

@end

@implementation GGRechargeLodingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithOrderNo:(NSString *)orderNo
{
    self = [super init];
    if (self) {
        _orderNo = orderNo;
    }
    return self;
}

- (void)setupView
{
    self.navigationItem.title = @"充值结果详情";
    self.navigationItem.hidesBackButton = YES;
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"完成" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self dismiss];
        if (self.popHandler) {
            self.popHandler(nil);
        }
    }];

    [self.view addSubview:self.tipImageView];
    
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(150);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.tipImageView.mas_bottom).offset(27);
    }];
    
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(112);
        make.left.equalTo(self.view).offset(35);
        make.right.equalTo(self.view).offset(-35);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self setTipViewContent:NO];
    self.requestTime = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getPayOrderStatus];
}

- (void)setTipViewContent:(BOOL)isSuccess
{
    if (isSuccess) {
        self.tipImageView.image = [UIImage imageNamed:@"rechage_result_success"];
        self.tipLabel.text = @"充值成功";
    }else{
        self.tipImageView.image = [UIImage imageNamed:@"rechage_result_loading"];
        self.tipLabel.text = @"银行处理中";
    }
}

- (void)gotoErrorView:(NSString *)errorMsg
{
    GGRechargeErrorViewController *errorVC;
    if (errorMsg) {
        errorVC = [[GGRechargeErrorViewController alloc] initErrorMsg:errorMsg];
    }else{
        errorVC = [[GGRechargeErrorViewController alloc] initBankTimeOut];
    }
    
    [errorVC setPopHandler:self.popHandler];
    [self pushTo:errorVC];
}

- (void)getPayOrderStatus
{
    if (!self.orderNo) {
        return;
    }
    self.requestTime += 1;

    if (self.requestTime >= 6) {
        [self gotoErrorView:nil];
        return;
    }
    
    @weakify(self);
    [[[[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *orderNo) {
        return [GGApiManager request_GetPayOrderWithParameter:@{@"orderNo":orderNo}];
    }] execute:self.orderNo] subscribeNext:^(id value) {
        @strongify(self);
        NSNumber *status = [value objectForKey:@"status"];
        NSInteger statusCode = [status integerValue];
        switch (statusCode) {
            case 1:
                [self setTipViewContent:YES];
                break;
            case 2:{
                NSString *failMsg = [value objectForKey:@"failMsg"];
                if (!failMsg) {
                    failMsg = @" ";
                }
                [self gotoErrorView:failMsg];
                break;
            }
            case 0:
                [self bk_performBlock:^(id obj) {
                    [obj getPayOrderStatus];
                } afterDelay:3];
                
                break;
        }
    } error:^(NSError *error) {
        [self bk_performBlock:^(id obj) {
            [obj getPayOrderStatus];
        } afterDelay:3];
    }];
}

#pragma mark - init View

- (UIImageView *)tipImageView
{
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] init];
    }
    return _tipImageView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [UIColor blackColor];
        _tipLabel.font = [UIFont systemFontOfSize:18];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = sectionColor;
    }
    return _lineView;
}

@end
