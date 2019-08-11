//
//  GGWarrantCarViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/2/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGWarrantCarViewController.h"
#import "GGWebViewController.h"
#import "GGCheckOrderViewController.h"
#import "GGCheckCarView.h"
#import "GGTitleValueCell.h"
#import "GGWarrantCarViewModel.h"
#import "GGCheckCarPageRoute.h"
#import "GGVehicleWarrantyItemCell.h"

@interface GGWarrantCarViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)GGWarrantCarViewModel *warrantCarViewModel;

@property (nonatomic,strong)UIView *tableHeaderView;
@property (nonatomic,strong)UIView *tableFooterView;


@property(nonatomic,strong)UIButton *appointmentButton;
@end

@implementation GGWarrantCarViewController


- (instancetype)initWithCarModel:(GGCar *)checkCar
{
    self = [super init];
    if (self) {
        _warrantCarViewModel = [[GGWarrantCarViewModel alloc] init];
        _warrantCarViewModel.checkCar = checkCar;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.title = @"预约质检";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindViewModel{
    @weakify(self);
    [RACObserve(self.warrantCarViewModel, dataSource) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [[self.appointmentButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *button) {
        @strongify(self);
        [button showIndicator];
        [[self.warrantCarViewModel.appointmentCommand execute:0] subscribeError:^(NSError *error) {
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

- (void)setupView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"14b2e6"];
    
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(76, 12, 12, 12));
    }];
    
    [self.tableView registerClass:[GGVehicleWarrantyItemCell class] forCellReuseIdentifier:kGGVehicleWarrantyItemCell];
    [self.bgView addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top);
        make.top.left.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView).offset(-70);
    }];
    
    [self.bgView addSubview:self.appointmentButton];
    [self.appointmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-20);
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(180, 46));
    }];
    
//    self.warrantCarViewModel.dataSource =  
    
}

#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.warrantCarViewModel.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGVehicleWarrantyItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kGGVehicleWarrantyItemCell];
    
    GGFormItem *item = [self.warrantCarViewModel.dataSource objectAtIndex:indexPath.row];
    [cell updateUIWithModel:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [tableView fd_heightForCellWithIdentifier:kGGVehicleWarrantyItemCell cacheByIndexPath:indexPath configuration:^(GGVehicleWarrantyItemCell *cell) {
//        GGFormItem *item = [self.checkCarVM itemForIndexPath:indexPath];
//        [cell updateUIWithModel:item];
//    }];
//}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
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
//        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.scrollEnabled = NO;
        
        [_tableView setTableHeaderView:self.tableHeaderView];
//        [self.tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.tableView);
//            make.height.mas_equalTo(120);
//        }];
        [_tableView setTableFooterView:self.tableFooterView];
//        [self.tableFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.tableView);
//            make.height.mas_equalTo(60);
//        }];

    }
    return _tableView;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.height, 100)];
        
        UILabel *label = [[UILabel alloc] init];
        
        label.font = [UIFont systemFontOfSize:18];
        label.text = @"质检信息";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [_tableHeaderView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.equalTo(_tableHeaderView);
        }];
        
    }
    return _tableHeaderView;
}

- (UIView *)tableFooterView
{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.height, 60)];
        
        UIImageView *checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_hao_che_bo_le"]];
        [_tableFooterView addSubview:checkImageView];
        [checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tableFooterView).offset(25);
            make.left.equalTo(_tableFooterView).offset(13);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"好车伯乐质检";
        label.textColor = [UIColor colorWithHexString:@"14b2e6"];
        [_tableFooterView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(checkImageView.mas_right).offset(8);
            make.centerY.equalTo(checkImageView);
        }];
    }
    return _tableFooterView;
}

- (GGWarrantCarViewModel *)warrantCarViewModel{
    if (!_warrantCarViewModel) {
        _warrantCarViewModel = [[GGWarrantCarViewModel alloc] init];
    }
    return _warrantCarViewModel;
}


- (UIButton *)appointmentButton{
    if (!_appointmentButton) {
        _appointmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_appointmentButton setTitle:@"立即预约" forState:UIControlStateNormal];
        [_appointmentButton setTitleColor:[UIColor colorWithHexString:@"14b2e6"] forState:UIControlStateNormal];
        [_appointmentButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"14b2e6"]] forState:UIControlStateHighlighted];
        [_appointmentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_appointmentButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
        _appointmentButton.layer.masksToBounds = YES;
        _appointmentButton.layer.borderColor = [UIColor colorWithHexString:@"14b2e6"].CGColor;
        _appointmentButton.layer.borderWidth = 1;
        _appointmentButton.layer.cornerRadius = 23;
        
    }
    return _appointmentButton;
}



@end
