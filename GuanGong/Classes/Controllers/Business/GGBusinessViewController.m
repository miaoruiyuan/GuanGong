//
//  GGBusinessViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBusinessViewController.h"
#import "GGBusinessViewModel.h"

#import "GGCreateCarViewController.h"
#import "GGVehicleManagementViewController.h"
#import "GGCarsOrderManagementViewController.h"
#import "GGBusinessChartCell.h"

#import "GGBusinessItemView.h"

@interface GGBusinessViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)GGBusinessViewModel *businessVM;

//@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *tableHeaderView;

@property(nonatomic,strong)UILabel *onSaleCountLabe;

@property(nonatomic,strong)UILabel *publishCountLabel;

@property(nonatomic,strong)UILabel *orderCountLabel;

@property(nonatomic,strong)UILabel *soldCountLabel;

@property(nonatomic,strong)UILabel *historyCountLabel;

@property(nonatomic,strong)UIButton *openChartCellBtn;


@property(nonatomic,strong)UIView *tableFooterView;

@property(nonatomic,strong)GGBusinessItemView *businessItemView;

@property(nonatomic,strong)UIButton *sendCarBtn;

@end

@implementation GGBusinessViewController

- (void)setupView
{
    self.navigationItem.title = @"生意";
    self.style = UITableViewStylePlain;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.baseTableView registerClass:[GGBusinessChartCell class] forCellReuseIdentifier:@"GGBusinessChartCell"];
    self.baseTableView.backgroundColor = tableBgColor;
    self.baseTableView.rowHeight = 212;
    
    [self.baseTableView setTableHeaderView:self.tableHeaderView];
    [self.baseTableView setTableFooterView:self.tableFooterView];
    [self setTableFooterviewHeight:self.businessVM.isOpen];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.enabledRefreshHeader = YES;
}

- (void)setTableFooterviewHeight:(BOOL)isOpen
{
    [self.baseTableView reloadData];
    if (isOpen) {
        self.tableFooterView.height = 200;
        self.businessItemView.frame = CGRectMake(0, 28, self.tableFooterView.width, 70);
    }else{
        self.tableFooterView.height = 240;
        self.businessItemView.frame = CGRectMake(0, 45, self.tableFooterView.width, 70);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDataRequest];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)bindViewModel
{
    _businessVM = [[GGBusinessViewModel alloc] init];
}

- (void)refreshHeaderAction
{
    [self getDataRequest];
}

- (void)getDataRequest
{
    @weakify(self);
    [[self.businessVM.loadData execute:0] subscribeError:^(NSError *error) {
        @strongify(self);
        self.baseTableView.hidden = YES;
        [self endRefreshHeader];
    } completed:^{
        @strongify(self);
        self.onSaleCountLabe.text = [NSString stringWithFormat:@"%ld",(long)self.businessVM.homeData.onSaleCarCount];
        
        self.publishCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.businessVM.homeData.currentMonthPublishCarCount];;
        self.orderCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.businessVM.homeData.currentMonthSoldCarCount];;
        
        self.soldCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.businessVM.homeData.currentMonthSoldCarCount];;
        self.historyCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.businessVM.homeData.totalSoldCarCount];;
        self.baseTableView.hidden = NO;
        [self.baseTableView reloadData];
        [self endRefreshHeader];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.businessVM.isOpen) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGBusinessChartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGBusinessChartCell"];
    if (cell) {
        [cell showChartByModel:nil];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

#pragma mark -  init Views

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,202)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        UILabel *onSaleCarTitltLabel = [[UILabel alloc] init];
        onSaleCarTitltLabel.text = @"在售车辆（辆）";
        onSaleCarTitltLabel.textColor = [UIColor colorWithHexString:@"8e8e8e"];
        onSaleCarTitltLabel.font = [UIFont systemFontOfSize:13];
        [_tableHeaderView addSubview:onSaleCarTitltLabel];
        
        [onSaleCarTitltLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tableHeaderView).offset(26);
            make.top.equalTo(_tableHeaderView).offset(60);
        }];
        
        [_tableHeaderView addSubview:self.onSaleCountLabe];
        [self.onSaleCountLabe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tableHeaderView).offset(26);
            make.top.equalTo(onSaleCarTitltLabel.mas_bottom).offset(2);
        }];
        
        UILabel *publishCarTitltLabel = [[UILabel alloc] init];
        publishCarTitltLabel.text = @"本月发车：";
        publishCarTitltLabel.textColor = [UIColor colorWithHexString:@"8e8e8e"];
        publishCarTitltLabel.font = [UIFont systemFontOfSize:13];
        [_tableHeaderView addSubview:publishCarTitltLabel];
        
        UILabel *orderCarTitltLabel = [[UILabel alloc] init];
        orderCarTitltLabel.text = @"本月下单：";
        orderCarTitltLabel.textColor = [UIColor colorWithHexString:@"8e8e8e"];
        orderCarTitltLabel.font = [UIFont systemFontOfSize:13];
        [_tableHeaderView addSubview:orderCarTitltLabel];
        
        UILabel *soldCarTitltLabel = [[UILabel alloc] init];
        soldCarTitltLabel.text = @"本月售出：";
        soldCarTitltLabel.textColor = [UIColor colorWithHexString:@"8e8e8e"];
        soldCarTitltLabel.font = [UIFont systemFontOfSize:13];
        [_tableHeaderView addSubview:soldCarTitltLabel];
        
        [_tableHeaderView addSubview:self.publishCountLabel];
        [_tableHeaderView addSubview:self.orderCountLabel];
        [_tableHeaderView addSubview:self.soldCountLabel];
        
        [publishCarTitltLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_tableHeaderView).offset(-60);
            make.top.equalTo(_tableHeaderView).offset(45);
        }];
        
        [self.publishCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(publishCarTitltLabel.mas_right);
            make.right.equalTo(_tableHeaderView).offset(-10);
            make.top.equalTo(publishCarTitltLabel);
        }];
        
        
        [orderCarTitltLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_tableHeaderView).offset(-60);
            make.top.equalTo(_tableHeaderView).offset(75);
        }];
        
        [self.orderCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(orderCarTitltLabel.mas_right);
            make.right.equalTo(_tableHeaderView).offset(-10);
            make.top.equalTo(orderCarTitltLabel);
        }];
        
        [soldCarTitltLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_tableHeaderView).offset(-60);
            make.top.equalTo(_tableHeaderView).offset(105);
        }];
        
        [self.soldCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(soldCarTitltLabel.mas_right);
            make.right.equalTo(_tableHeaderView).offset(-10);
            make.top.equalTo(soldCarTitltLabel);
        }];
   
        UILabel *historyCountTitltLabel = [[UILabel alloc] init];
        historyCountTitltLabel.text = @"历史共计售出";
        historyCountTitltLabel.textColor = [UIColor colorWithHexString:@"8e8e8e"];
        historyCountTitltLabel.font = [UIFont systemFontOfSize:13];
        [_tableHeaderView addSubview:historyCountTitltLabel];
        [historyCountTitltLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tableHeaderView).offset(26);
            make.top.equalTo(_tableHeaderView).offset(169);
        }];
        
        [_tableHeaderView addSubview:self.historyCountLabel];
    
        [self.historyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(historyCountTitltLabel.mas_right).offset(3);
            make.top.equalTo(historyCountTitltLabel);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = sectionColor;
        [_tableHeaderView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tableHeaderView).offset(150);
            make.left.right.equalTo(_tableHeaderView);
            make.height.mas_equalTo(0.5);
        }];
        
        
        [_tableHeaderView addSubview:self.openChartCellBtn];
        
        [self.openChartCellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_tableHeaderView);
            make.right.equalTo(_tableHeaderView);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(50);
        }];
        
    }
    return _tableHeaderView;
}

- (UIButton *)openChartCellBtn
{
    if (!_openChartCellBtn) {
        _openChartCellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openChartCellBtn setImage:[UIImage imageNamed:@"btn_show_chart"] forState:UIControlStateNormal];

        [[_openChartCellBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            self.businessVM.isOpen = !self.businessVM.isOpen;
            [self setTableFooterviewHeight:self.businessVM.isOpen];
            
            if (self.businessVM.isOpen) {
                [self.openChartCellBtn setImage:[UIImage imageNamed:@"btn_close_chart"] forState:UIControlStateNormal];
            }else{
                [self.openChartCellBtn setImage:[UIImage imageNamed:@"btn_show_chart"] forState:UIControlStateNormal];
            }
        }];
    }
    return _openChartCellBtn;
}

- (UIView *)tableFooterView
{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] init];
        _tableFooterView.backgroundColor = [UIColor whiteColor];
        [_tableFooterView addSubview:self.businessItemView];
        [_tableFooterView addSubview:self.sendCarBtn];
        [self.sendCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tableFooterView).offset(12);
            make.right.equalTo(_tableFooterView).offset(-12);
            make.bottom.equalTo(_tableFooterView).offset(-30);
            make.height.mas_equalTo(50);
        }];
    }
    return _tableFooterView;
}

- (UILabel *)onSaleCountLabe
{
    if (!_onSaleCountLabe) {
        _onSaleCountLabe = [[UILabel alloc] init];
        _onSaleCountLabe.textColor = [UIColor colorWithHexString:@"333333"];
        _onSaleCountLabe.font = [UIFont systemFontOfSize:30];
    }
    return _onSaleCountLabe;
}

- (UILabel *)publishCountLabel
{
    if (!_publishCountLabel) {
        _publishCountLabel = [[UILabel alloc] init];
        _publishCountLabel.textColor = [UIColor blackColor];
        _publishCountLabel.font = [UIFont systemFontOfSize:13];
    }
    return _publishCountLabel;
}

- (UILabel *)orderCountLabel
{
    if (!_orderCountLabel) {
        _orderCountLabel = [[UILabel alloc] init];
        _orderCountLabel.textColor = [UIColor blackColor];
        _orderCountLabel.font = [UIFont systemFontOfSize:13];
    }
    return _orderCountLabel;
}

- (UILabel *)soldCountLabel
{
    if (!_soldCountLabel) {
        _soldCountLabel = [[UILabel alloc] init];
        _soldCountLabel.textColor = [UIColor blackColor];
        _soldCountLabel.font = [UIFont systemFontOfSize:13];
    }
    return _soldCountLabel;
}

- (UILabel *)historyCountLabel
{
    if (!_historyCountLabel) {
        _historyCountLabel = [[UILabel alloc] init];
        _historyCountLabel.textColor = [UIColor blackColor];
        _historyCountLabel.font = [UIFont systemFontOfSize:13];
    }
    return _historyCountLabel;
}

- (GGBusinessItemView *)businessItemView
{
    if (!_businessItemView) {
        _businessItemView = [[GGBusinessItemView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 100)];
        
        @weakify(self);
        _businessItemView.click = ^(NSInteger tag){
            @strongify(self)
            switch (tag) {
                case 0:{
                    GGVehicleManagementViewController *vehicleManagementVC = [[GGVehicleManagementViewController alloc]init];
                    [self.navigationController pushViewController:vehicleManagementVC  animated:YES];
                }
                    break;
                case 1:{
                    GGCarsOrderManagementViewController *carOrderManagementVC = [[GGCarsOrderManagementViewController alloc] initSellerController:NO];
                    [self pushTo:carOrderManagementVC];
                }
                    break;
                case 2:{
                    GGCarsOrderManagementViewController *carOrderManagementVC = [[GGCarsOrderManagementViewController alloc] initSellerController:YES];
                    [self pushTo:carOrderManagementVC];
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _businessItemView;
}

- (UIButton *)sendCarBtn
{
    if (!_sendCarBtn) {
        _sendCarBtn =
        [UIButton buttonWithType:UIButtonTypeCustom];
        _sendCarBtn.backgroundColor = themeColor;
        _sendCarBtn.layer.masksToBounds = YES;
        _sendCarBtn.layer.cornerRadius = 2;
        [_sendCarBtn setTitle:@"   发布车辆" forState:UIControlStateNormal];
        _sendCarBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendCarBtn setImage:[UIImage imageNamed:@"Business_send_car_btn"] forState:UIControlStateNormal];
        
        [_sendCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [[_sendCarBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            GGCreateCarViewController *creatVC = [[GGCreateCarViewController alloc] init];
            [[self class] presentVC:creatVC];
        }];
    }
    return _sendCarBtn;
}

@end
