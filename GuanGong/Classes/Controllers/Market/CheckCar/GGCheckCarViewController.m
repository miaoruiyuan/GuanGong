//
//  GGCheckCarViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckCarViewController.h"
#import "GGWebViewController.h"
#import "GGCheckOrderViewController.h"
#import "GGCheckCarView.h"
#import "GGTitleValueCell.h"
#import "GGCheckCarViewModel.h"
#import "GGCheckCarPageRoute.h"

@interface GGCheckCarViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)GGCheckCarView *bgView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)GGCheckCarViewModel *checkCarVM;

@property(nonatomic,strong)UIButton *appointmentButton;


@end

@implementation GGCheckCarViewController{
    NSDictionary *_identifier;
}

- (void)bindViewModel{
    @weakify(self);
    [RACObserve(self.checkCarVM, dataSource)subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    //监听vin并识别
    [[RACObserve(self.checkCarVM.checkCar, vin) skip:1]subscribeNext:^(NSString *x) {
        @strongify(self);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[self.checkCarVM.vinCommand execute:x]subscribeError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } completed:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }];

    
    
    [[self.appointmentButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *button) {
        @strongify(self);
        [button showIndicator];
        [[self.checkCarVM.appointmentCommand execute:0]subscribeError:^(NSError *error) {
            [button hideIndicator];
        } completed:^{
            [button hideIndicator];            
            [UIAlertController alertInController:self title:@"预约成功" message:@"请您耐心等待,好车伯乐客服将尽快和你确认订单" confrimBtn:@"确定" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
                GGCheckOrderViewController *orderVC = [[GGCheckOrderViewController alloc] init];
                [self pushTo:orderVC];
            } cancelBtn:nil cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
            
        }];
    }];
    
}

- (void)setupView{
    self.view.backgroundColor = tableBgColor;
    self.navigationItem.title = @"车辆质检";
    [self.tableView registerClass:[GGTitleValueCell class] forCellReuseIdentifier:kCellIdentifierTitleValue];
    _identifier = @{@(GGFormCellTypeNormal):kCellIdentifierTitleValue};

    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(12);
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
         
    }];
    
    
    [self.bgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(145);
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(226);
    }];
    
    [self.bgView addSubview:self.appointmentButton];
    [self.appointmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(25);
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(180, 46));
    }];
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"质检订单" style:UIBarButtonItemStylePlain handler:^(id sender) {
        
        @strongify(self);
        GGCheckOrderViewController *checkOrderVC = [[GGCheckOrderViewController alloc] init];
        [self pushTo:checkOrderVC];
    }];
    
    
    //查看价格
    [[self.bgView.priceButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
        
        GGWebViewController *webVC = [[GGWebViewController alloc] init];
        webVC.url = GGCheckCarPriceUrl;
        [GGCheckCarViewController presentVC:webVC];
    }];
    

}

#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.checkCarVM sectionCount];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.checkCarVM itemCountAtSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGFormItem *item = [self.checkCarVM itemForIndexPath:indexPath];
    GGFormBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifier[@(item.cellType)]];
    [cell configItem:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GGFormItem *item = [self.checkCarVM itemForIndexPath:indexPath];
    [GGCheckCarPageRoute pushWithItem:item nav:self.navigationController callBack:^(id x) {
        
        [self.checkCarVM.reloadData execute:x];
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0 hasSectionLine:NO];
}


- (GGCheckCarView *)bgView{
    if (!_bgView) {
        _bgView = [[GGCheckCarView alloc] init];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 3.0;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (GGCheckCarViewModel *)checkCarVM{
    if (!_checkCarVM) {
        _checkCarVM = [[GGCheckCarViewModel alloc] init];
    }
    return _checkCarVM;
}


- (UIButton *)appointmentButton{
    if (!_appointmentButton) {
        _appointmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_appointmentButton setTitle:@"立即预约" forState:UIControlStateNormal];
        [_appointmentButton setTitleColor:[UIColor colorWithHexString:@"14b2e6"] forState:UIControlStateNormal];
        [_appointmentButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"14b2e6"]] forState:UIControlStateHighlighted];
        [_appointmentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_appointmentButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightLight]];
        _appointmentButton.layer.masksToBounds = YES;
        _appointmentButton.layer.borderColor = [UIColor colorWithHexString:@"14b2e6"].CGColor;
        _appointmentButton.layer.borderWidth = 1;
        _appointmentButton.layer.cornerRadius = 23;
        
    }
    return _appointmentButton;
}



@end
