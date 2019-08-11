//
//  GGRechargeErrorViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/8/11.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGRechargeErrorViewController.h"

@interface GGRechargeErrorViewController ()

@property (nonatomic,strong) NSString *errorMsg;

@property (nonatomic,strong) UIImageView *tipImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *chooseOtherBtn;
@property (nonatomic,strong) NSString *errorTitle;

@end

@implementation GGRechargeErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initErrorMsg:(NSString *)errorMsg
{
    self = [super init];
    if (self) {
        _errorTitle = @"充值失败";
        _errorMsg = errorMsg;
    }
    return self;
}

- (instancetype)initBankTimeOut
{
    self = [super init];
    if (self) {
        _errorTitle = @"银行处理超时";
        _errorMsg = @"请检查银行卡余额是否充足";
    }
    return self;
}

- (void)setupView
{
    self.navigationItem.title = @"充值结果详情";
    self.navigationItem.hidesBackButton = YES;
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self dismiss];
        if (self.popHandler) {
            self.popHandler(nil);
        }
    }];
    
    [self.view addSubview:self.tipImageView];
    
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(130);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.tipImageView.mas_bottom).offset(20);
    }];
    
    [self.view addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(35);
        make.right.equalTo(self.view).offset(-35);
    }];
    
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLabel.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(35);
        make.right.equalTo(self.view).offset(-35);
        make.height.mas_equalTo(0.5f);
    }];
    
    
    [self.view addSubview:self.chooseOtherBtn];
    [self.chooseOtherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).mas_offset(50);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(104, 32));
    }];
    
    [self setTitleAndDes];
}

- (void)setTitleAndDes
{
    self.titleLabel.text = self.errorTitle;
    self.desLabel.text = self.errorMsg;
    self.tipImageView.image = [UIImage imageNamed:@"rechage_result_error"];
    
    if ([self.errorTitle isEqualToString:@"银行处理超时"]) {
        [self.chooseOtherBtn setTitle:@"选择其他银行卡" forState:UIControlStateNormal];
    }else{
        [self.chooseOtherBtn setTitle:@"重新充值" forState:UIControlStateNormal];
    }
}

#pragma mark - init View

- (UIImageView *)tipImageView
{
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] init];
    }
    return _tipImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _desLabel.font = [UIFont systemFontOfSize:12];
        _desLabel.numberOfLines = 0;
        _desLabel.preferredMaxLayoutWidth = kScreenWidth - 70;
        _desLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _desLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = sectionColor;
    }
    return _lineView;
}


- (UIButton *)chooseOtherBtn
{
    if (!_chooseOtherBtn) {
        _chooseOtherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_chooseOtherBtn setTitle:@"选择其他银行卡" forState:UIControlStateNormal];
        [_chooseOtherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _chooseOtherBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _chooseOtherBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _chooseOtherBtn.layer.borderWidth = 0.5f;
        
        @weakify(self);

        [[_chooseOtherBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self dismiss];
        }];
    }
    
    return _chooseOtherBtn;
}
@end
