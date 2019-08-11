//
//  GGMinePhoneViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/7/18.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGMinePhoneViewController.h"
#import "GGChangePhoneViewController.h"

#import "UINavigationBar+GGAwesome.h"

@interface GGMinePhoneViewController ()

@property (nonatomic,strong)GGFormItem *item;

@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *bingTipLabel;
@property (nonatomic,strong)UILabel *phoneLabel;
@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,strong)UIButton *changePhoneBtn;
@property (nonatomic,strong)UILabel *desLabel;

@end

@implementation GGMinePhoneViewController

- (instancetype)initWithItem:(GGFormItem *)item
{
    self = [super init];
    if (self) {
        _item = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView
{
    [self.view addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(89);
        make.size.mas_equalTo(CGSizeMake(95, 81));
    }];
    
    [self.view addSubview:self.bingTipLabel];
    [self.bingTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(20);
    }];
    
    
    [self.view addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.bingTipLabel.mas_bottom).offset(10);
    }];
    
    
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(37);
        make.right.equalTo(self.view).offset(-37);
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(50);
        make.height.mas_equalTo(0.5f);

    }];
    
    [self.view addSubview:self.changePhoneBtn];
    [self.changePhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(37);
        make.right.equalTo(self.view).offset(-37);
        make.top.equalTo(self.lineView.mas_bottom).offset(60);
        make.height.mas_equalTo(45);
    }];
    
    
    [self.view addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.changePhoneBtn.mas_bottom).offset(15);
    }];
}

- (void)bindViewModel
{
    self.bingTipLabel.text = @"绑定手机号";
    self.phoneLabel.text = (NSString *)self.item.obj;
    self.desLabel.text = @"一个手机号只能绑定一个关二爷账户";
    
    @weakify(self);
    [[self.changePhoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        GGChangePhoneViewController *changePhoneVC = [[GGChangePhoneViewController alloc] init];
        [self pushTo:changePhoneVC];
    }];
}

#pragma mark - init View

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mine_phone"]];
    }
    return _iconImageView;
}

- (UILabel *)bingTipLabel
{
    if (!_bingTipLabel) {
        _bingTipLabel = [[UILabel alloc] init];
        _bingTipLabel.textAlignment = NSTextAlignmentCenter;
        _bingTipLabel.font = [UIFont systemFontOfSize:13];
        _bingTipLabel.textColor = [UIColor blackColor];
    }
    return _bingTipLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
        _phoneLabel.font = [UIFont systemFontOfSize:18];
        _phoneLabel.textColor = [UIColor blackColor];
    }
    return _phoneLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    }
    return _lineView;
}

- (UIButton *)changePhoneBtn
{
    if (!_changePhoneBtn) {
        _changePhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changePhoneBtn setTitle:@"更换手机号" forState:UIControlStateNormal];
        [_changePhoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _changePhoneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_changePhoneBtn setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        _changePhoneBtn.layer.masksToBounds = YES;
        _changePhoneBtn.layer.cornerRadius = 3;
    }
    return _changePhoneBtn;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.font = [UIFont systemFontOfSize:12];
        _desLabel.textColor = [UIColor colorWithHexString:@"737373"];
    }
    return _desLabel;
}
@end
