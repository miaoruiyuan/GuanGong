//
//  GGNewCarOrderDetailViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/10.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGNewCarOrderDetailViewController.h"
#import "GGNewCarOrderViewModel.h"
#import "GGTransferAccountViewModel.h"
#import "GGNewCarListAlertView.h"
#import "GGNewCarOrderBaseInfoCell.h"
#import "GGCarOrderExpressCell.h"
#import "GGCarOrderPriceCell.h"

#import "GGTransferDetailViewController.h"
#import "GGLabel.h"

@interface GGNewCarOrderDetailViewController ()

@property (nonatomic,strong)GGNewCarOrderViewModel *orderVM;
@property (nonatomic,strong)GGLabel *reservePriceLabel;
@property (nonatomic,strong)UIButton *submitButton;
@property (nonatomic,assign)NSInteger buyNewCount;

@end

@implementation GGNewCarOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNewCarDetail:(GGNewCarDetailModel *)carDetailModel
{
    if (self = [super init]) {
        _orderVM = [[GGNewCarOrderViewModel alloc] init];
        _orderVM.carDetailModel = carDetailModel;
        _buyNewCount = _orderVM.carDetailModel.minQuantity;
    }
    return self;
}

- (void)setupView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"确认订单";
    [self.view addSubview:self.reservePriceLabel];
    [self.view addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140, 48));
        make.right.bottom.equalTo(self.view);
    }];
    [self.reservePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.right.equalTo(self.submitButton.mas_left);
        make.height.mas_equalTo(48);
    }];
    
    [self.baseTableView registerClass:[GGNewCarOrderBaseInfoCell class] forCellReuseIdentifier:kGGNewCarOrderBaseInfoCellID];
    [self.baseTableView registerClass:[GGCarOrderPriceCell class] forCellReuseIdentifier:kCellIdentifierCarOrderPrice];
    [self.baseTableView registerClass:[GGCarOrderExpressCell class] forCellReuseIdentifier:kCellIdentifierCarOrderExpress];
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.reservePriceLabel.mas_top);
    }];
    
    [self.baseTableView setTableFooterView:[self tableFooterView]];
}

- (void)bindViewModel
{
    @weakify(self);
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [UIAlertController alertInController:self title:nil message:[self getAlertMessage] confrimBtn:@"取消" confrimStyle:UIAlertActionStyleDestructive confrimAction:nil cancelBtn:@"确定" cancelStyle:UIAlertActionStyleDefault cancelAction:^{
            @strongify(self);
            [self pushToPayView];
        }];
    }];
}

- (NSString *)getAlertMessage
{
    NSInteger hour = self.orderVM.carDetailModel.guaranteeTimes/1000/60/60;
    NSString *time = @"";
    if (hour/24.0 > 1) {
        time = [NSString stringWithFormat:@"%ld天",hour/24];
    }else{
        time = [NSString stringWithFormat:@"%ld小时",(long)hour];
    }
    
    NSString *message = [NSString stringWithFormat:@"支付定金后，请在%@内付清尾款，否则订单将自动关闭，定金不予退回。",time];
    return message;
}

- (void)pushToPayView
{
    [MBProgressHUD showMessage:@"正在下单..." toView:self.view];
    @weakify(self);
    [[self.orderVM.carOrderCommand execute:@(self.buyNewCount)] subscribeError:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
    } completed:^{
        
        @strongify(self);
        
        GGTransferAccountViewModel *accountVM = [[GGTransferAccountViewModel alloc] init];
        accountVM.account.realName = self.orderVM.carOrderDetail.car.user.realName;
        accountVM.account.mobile = self.orderVM.carOrderDetail.car.user.mobile;
        accountVM.account.userId = self.orderVM.carOrderDetail.car.user.userId;
        accountVM.trade.orderNo = self.orderVM.carOrderDetail.orderNo;
        accountVM.goodsType = GoodsTypeCar;
        accountVM.payType = PaymentTypeFDJ;
        accountVM.trade.tranAmount = self.orderVM.carOrderDetail.reservePrice;
        
        [MBProgressHUD hideHUDForView:self.view];
        
        GGTransferDetailViewController *transferDetailVC = [[GGTransferDetailViewController alloc] initWithObject:accountVM];
        [transferDetailVC setPopHandler:^(id value){
            if (self.popHandler) {
                self.popHandler(self.orderVM.carOrderDetail.orderNo);
            }
            [self.navigationController popViewControllerAnimated:NO];
        }];
        [[self class] presentVC:transferDetailVC];
    }];
}

#pragma mark- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GGNewCarOrderBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kGGNewCarOrderBaseInfoCellID];
        [cell updateUIWithNewCarModel:self.orderVM.carDetailModel];
        @weakify(self);
        [cell setCountChangeBlock:^(NSInteger count) {
            @strongify(self);
            [self setTotalMoney:count];
        }];
        return cell;
    }else if (indexPath.section == 1){
        GGCarOrderPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCarOrderPrice];
        NSString *reservePrice = [NSString stringWithFormat:@"%0.2f",[self.orderVM.carDetailModel.reservePrice floatValue] * self.buyNewCount];
        NSString *finalPrice = [NSString stringWithFormat:@"%0.2f",[self.orderVM.carDetailModel.finalPrice floatValue] * self.buyNewCount];
        [cell showUIWithReservePrice:reservePrice finalPrice:finalPrice];
        return cell;
    } else {
        GGCarOrderExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCarOrderExpress];
        
        NSInteger logisticsType = self.orderVM.carDetailModel.logisticsType;
        if (logisticsType == 1) {
            [cell showTitle:@"配送方式" content:@"自取"];
        }else if (logisticsType == 2){
            [cell showTitle:@"配送方式" content:@"包物流"];
        }

        return cell;
    }
}

- (void)setTotalMoney:(NSInteger)count
{
    self.buyNewCount = count;
    
    NSString *reservePrice = [NSString stringWithFormat:@"支付订金: ¥%0.2f",[self.orderVM.carDetailModel.reservePrice floatValue] * self.buyNewCount];
    self.reservePriceLabel.text = reservePrice;
    
    [self.baseTableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 224;
            break;
        case 1:
            return 72;
            break;
        default:
            return 44;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0.1;
    }
    return 12;
}

#pragma mark - init View

- (UIView *)tableFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.frame = CGRectMake(5, 10, 56, 20);
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [agreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"buy_new_car_agree_btn_n"] forState:UIControlStateNormal];
    [footerView addSubview:agreeBtn];
    
    UIButton *buyTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyTipBtn.frame = CGRectMake(52, 5, 80, 30);
    [buyTipBtn setTitle:@"《抢购规则》" forState:UIControlStateNormal];
    buyTipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [buyTipBtn setTitleColor:[UIColor colorWithHexString:@"007aff"] forState:UIControlStateNormal];
    [footerView addSubview:buyTipBtn];
    
    [[buyTipBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        [GGNewCarListAlertView showContent:[GGNewCarListAlertView getDefaultContent] andBlock:nil];
    }];
    return footerView;
}

- (GGLabel *)reservePriceLabel{
    if (!_reservePriceLabel) {
        _reservePriceLabel = [[GGLabel alloc] init];
        
        
        NSString *reservePrice = [NSString stringWithFormat:@"支付订金: ¥%0.2f",[self.orderVM.carDetailModel.reservePrice floatValue] * self.buyNewCount];

        _reservePriceLabel.text = reservePrice;
        _reservePriceLabel.textColor = themeColor;
        _reservePriceLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _reservePriceLabel.textAlignment = NSTextAlignmentRight;
        _reservePriceLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    }
    return _reservePriceLabel;
}

- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _submitButton;
}

@end
