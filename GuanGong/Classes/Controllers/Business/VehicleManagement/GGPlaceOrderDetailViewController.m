//
//  GGPlaceOrderDetailViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPlaceOrderDetailViewController.h"
#import "GGTransferDetailViewController.h"
#import "GGCarOrderBaseInfoCell.h"
#import "GGCarOrderExpressCell.h"
#import "GGCarOrderPriceCell.h"
#import "GGLabel.h"
#import "GGPlaceOrderViewModel.h"
#import "GGTransferAccountViewModel.h"

@interface GGPlaceOrderDetailViewController ()

@property(nonatomic,strong)GGPlaceOrderViewModel *placeOrderVM;
@property(nonatomic,strong)GGLabel *reservePriceLabel;
@property(nonatomic,strong)UIButton *submitButton;

@end

@implementation GGPlaceOrderDetailViewController

- (id)initWithCarInfo:(GGCar *)car{
    
    if (self = [super init]) {
        self.placeOrderVM.car = car;
    }
    return self;
}



- (void)bindViewModel
{
    [[self.placeOrderVM.placeOrderCommand.executing skip:1]subscribeNext:^(NSNumber *x) {
        if (x.boolValue) {
            [MBProgressHUD showMessage:@"下单中" toView:self.view];
        }else{
            [MBProgressHUD hideHUDForView:self.view];
        }
    }];
    
    @weakify(self);
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [[self.placeOrderVM.placeOrderCommand execute:nil] subscribeCompleted:^{
            GGTransferAccountViewModel *accountVM = [[GGTransferAccountViewModel alloc] init];
            accountVM.account.realName = self.placeOrderVM.carOrderDetail.car.user.realName;
            accountVM.account.mobile = self.placeOrderVM.carOrderDetail.car.user.mobile;
            accountVM.account.userId = self.placeOrderVM.carOrderDetail.car.user.userId;
            accountVM.trade.orderNo = self.placeOrderVM.carOrderDetail.orderNo;
            accountVM.goodsType = GoodsTypeCar;
            
            accountVM.payType = PaymentTypeFDJ;
            accountVM.trade.tranAmount = self.placeOrderVM.carOrderDetail.reservePrice;
            
            GGTransferDetailViewController *transferDetailVC = [[GGTransferDetailViewController alloc] initWithObject:accountVM];
            [self pushTo:transferDetailVC];
        }];
    }];

}

- (void)setupView{
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
    
    [self.baseTableView registerClass:[GGCarOrderBaseInfoCell class] forCellReuseIdentifier:kCellIdentifierCarOrderBaseInfo];
    [self.baseTableView registerClass:[GGCarOrderPriceCell class] forCellReuseIdentifier:kCellIdentifierCarOrderPrice];
    [self.baseTableView registerClass:[GGCarOrderExpressCell class] forCellReuseIdentifier:kCellIdentifierCarOrderExpress];
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.reservePriceLabel.mas_top);
    }];
    
    [self.baseTableView setTableFooterView:[self tableFooterView]];
    
}

#pragma mark- TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GGCarOrderBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCarOrderBaseInfo];
        cell.car = self.placeOrderVM.car;
        return cell;
    }else if (indexPath.section == 1){
        GGCarOrderPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCarOrderPrice];
        cell.car = self.placeOrderVM.car;
        return cell;
    }else{
        GGCarOrderExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCarOrderExpress];
        return cell;

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

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
//    if (section == 2) {
//        return @"此交易为担保支付交易,买家确认收货后才会打款给卖家";
//    }
//    return @"";
//}


- (UILabel *)tableFooterView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32)];
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"此交易为担保支付交易,买家确认收货后才会打款给卖家";
    label.textColor = textLightColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    return label;
}


- (GGLabel *)reservePriceLabel{
    if (!_reservePriceLabel) {
        _reservePriceLabel = [[GGLabel alloc] init];
        _reservePriceLabel.text = [NSString stringWithFormat:@"支付订金: ¥%@",self.placeOrderVM.car.reservePrice];
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


- (GGPlaceOrderViewModel *)placeOrderVM{
    if (!_placeOrderVM) {
        _placeOrderVM = [[GGPlaceOrderViewModel alloc] init];
    }
    return _placeOrderVM;
}


@end
