//
//  GGCarHistorySearvicePriceListController.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/12.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGCarHistorySearvicePriceListController.h"
#import "GGServicePriceListCell.h"
#import "GGTransferDetailViewController.h"

#import "GGVinInfoServicePriceViewModel.h"
#import "GGCarHistorySearvicePriceViewModel.h"

@interface GGCarHistorySearvicePriceListController ()

@property (nonatomic,strong) GGCarHistorySearvicePriceViewModel *carHistrpyPriceListVM;
@property (nonatomic,strong) GGVinInfoServicePriceViewModel *vinPriceListVM;

@property (nonatomic,strong) CWTSearchVinViewModel *searchVinVM;

@property (nonatomic,strong) GGVinInfoViewModel *vinInfoVM;

@property (nonatomic,assign) BOOL isMaintain;

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UIView *tableSectionHeaderView;
@property (nonatomic,strong) UILabel *serviceTitleLabel;
@property (nonatomic,strong) UILabel *desTitleLabel;

@end

@implementation GGCarHistorySearvicePriceListController

- (instancetype)initWithSearchVinVM:(CWTSearchVinViewModel *)searchVinVM
{
    self = [super init];
    if (self) {
        _searchVinVM = searchVinVM;
        _isMaintain = YES;
    }
    return self;
}

- (instancetype)initWithVinInfoVM:(GGVinInfoViewModel *)vinInfoVM
{
    self = [super init];
    if (self) {
        _vinInfoVM = vinInfoVM;
        _isMaintain = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"购买次数";
    self.style = UITableViewStylePlain;
    
    self.view.backgroundColor = tableBgColor;
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    
    self.baseTableView.rowHeight = 76;
    [self.baseTableView registerClass:[GGServicePriceListCell class] forCellReuseIdentifier:kGGServicePriceListCellID];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(self.view);
    }];

    if (self.isMaintain) {
        self.countLabel.text = [NSString stringWithFormat:@"%ld次",(long)[self.searchVinVM.balance integerValue]];
    }else{
        self.countLabel.text = [NSString stringWithFormat:@"%ld次",(long)[self.vinInfoVM.balance integerValue]];
    }
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
    self.carHistrpyPriceListVM = [[GGCarHistorySearvicePriceViewModel alloc] init];
    self.carHistrpyPriceListVM.serviceCompany = self.searchVinVM.serviceCompany;
    @weakify(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[self.carHistrpyPriceListVM.servicePriceListCommand execute:nil] subscribeError:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } completed:^{
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.baseTableView reloadData];
        self.serviceTitleLabel.text = @"剩余查询次数";
        self.desTitleLabel.text = @"维保查询套餐";
    }];
    [self refreshAccountInfo];
}

- (void)bindVinInfoVM
{
    self.vinPriceListVM = [[GGVinInfoServicePriceViewModel alloc] init];
//    self.vinPriceListVM.serviceCompany = self.vinInfoVM.serviceCompany;
    @weakify(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[self.vinPriceListVM.servicePriceListCommand execute:nil] subscribeError:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } completed:^{
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.baseTableView reloadData];
        self.serviceTitleLabel.text = @"剩余查询次数";
        self.desTitleLabel.text = @"VIN查询套餐";
    }];
    [self refreshAccountInfo];
}

- (void)refreshAccountInfo
{
    [[[GGApiManager request_AccountInfo] map:^id(NSDictionary *value) {
        GGWallet *wallet = [GGWallet modelWithDictionary:value];
        [[GGLogin shareUser] updateAmount:wallet];
        return [RACSignal empty];
    }] subscribeNext:^(id x) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  
- (void)createCarHistoryRecharge:(GGSearvicePriceListModel *)model
{
    @weakify(self)
    [[[self.carHistrpyPriceListVM createRechargeCommand] execute:model.priceId] subscribeNext:^(id x) {
        DLog(@"%@",self.carHistrpyPriceListVM.orderModel);
        @strongify(self);
        GGTransferAccountViewModel *transferVM = [[GGTransferAccountViewModel alloc] init];
        transferVM.isTransfer = YES;
        transferVM.goodsType = GoodsTypeCarHistory;
        transferVM.account.userId = [self.carHistrpyPriceListVM.orderModel.operUserId numberValue];
        transferVM.account.realName = self.carHistrpyPriceListVM.orderModel.service.companyName;
        transferVM.trade.tranAmount = [self.carHistrpyPriceListVM.orderModel.price.price stringValue];
        transferVM.trade.orderNo = self.carHistrpyPriceListVM.orderModel.orderNo;
        
        GGTransferDetailViewController *vc = [[GGTransferDetailViewController alloc] initWithObject:transferVM];
        [vc setPopHandler:^(NSNumber *value){
            if(value.boolValue){
                [self pop];
            }
        }];
        [[self class] presentVC:vc];
    } error:^(NSError *error) {
        
    }];
}

- (void)createVINRecharge:(GGSearvicePriceListModel *)model
{
    @weakify(self)
    [[[self.vinPriceListVM createRechargeCommand] execute:model.priceId] subscribeNext:^(id x) {
        DLog(@"%@",self.carHistrpyPriceListVM.orderModel);
        @strongify(self);
        GGTransferAccountViewModel *transferVM = [[GGTransferAccountViewModel alloc] init];
        transferVM.isTransfer = YES;
        transferVM.goodsType = GoodsTypeVinInfo;
        transferVM.account.userId = [self.vinPriceListVM.orderModel.operUserId numberValue];
        transferVM.account.realName = self.vinPriceListVM.orderModel.service.companyName;
        transferVM.trade.tranAmount = [self.vinPriceListVM.orderModel.price.price stringValue];
        transferVM.trade.orderNo = self.vinPriceListVM.orderModel.orderNo;
        
        GGTransferDetailViewController *vc = [[GGTransferDetailViewController alloc] initWithObject:transferVM];
        [vc setPopHandler:^(NSNumber *value){
            if(value.boolValue){
                [self pop];
            }
        }];
        [[self class] presentVC:vc];
        
    } error:^(NSError *error) {
        
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isMaintain) {
        NSInteger count = self.carHistrpyPriceListVM.dataSource.count;
        return count;
    }else{
        NSInteger count = self.vinPriceListVM.dataSource.count;
        return count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGServicePriceListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGGServicePriceListCellID];
    GGSearvicePriceListModel *listModel;
    if (self.isMaintain) {
        listModel = self.carHistrpyPriceListVM.dataSource[indexPath.row];
    }else{
        listModel = self.vinPriceListVM.dataSource[indexPath.row];
    }
    [cell updateUIWithModel:listModel];
    @weakify(self);
    [[[cell.buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        if (self.isMaintain) {
            [self createCarHistoryRecharge:listModel];
        }else{
            [self createVINRecharge:listModel];
        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
}

#pragma mark -  UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableSectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

#pragma mark - init View

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UIImageView *headerBGImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"car_history_buy_price_list_icon"]];
        [_headerView addSubview:headerBGImageView];

        [headerBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerView);
            make.centerY.equalTo(_headerView);
            make.size.mas_equalTo(CGSizeMake(135, 100));
        }];
        
        _serviceTitleLabel = [[UILabel alloc] init];
        _serviceTitleLabel.font = [UIFont systemFontOfSize:14];
        _serviceTitleLabel.textColor = [UIColor colorWithHexString:@"8e8e8e"];
        _serviceTitleLabel.text = @"剩余查询次数";
        [_headerView addSubview:_serviceTitleLabel];
        [_serviceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(25);
            make.top.equalTo(_headerView).offset(22);
            make.height.mas_equalTo(16);
        }];
        
        [_headerView addSubview:self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_serviceTitleLabel);
            make.top.equalTo(_serviceTitleLabel.mas_bottom).offset(8);
            make.height.mas_equalTo(28);
        }];
        
        UIView *bottomLineView = [[UIView alloc] init];
        bottomLineView.backgroundColor = sectionColor;
        [_headerView addSubview:bottomLineView];
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_headerView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _headerView;
}

- (UILabel *)countLabel
{
    if(!_countLabel){
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:25];
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.text = @"0次";
    }
    return _countLabel;
}

- (UIView *)tableSectionHeaderView
{
    if (!_tableSectionHeaderView) {
        _tableSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
        _tableSectionHeaderView.backgroundColor = [UIColor whiteColor];
        
        UIView *topLineView = [[UIView alloc] init];
        topLineView.backgroundColor = sectionColor;
        [_tableSectionHeaderView addSubview:topLineView];
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_tableSectionHeaderView);
            make.height.mas_equalTo(0.5);
        }];
        
        _desTitleLabel = [[UILabel alloc] init];
        _desTitleLabel.font = [UIFont systemFontOfSize:14];
        _desTitleLabel.textColor = [UIColor blackColor];
        
        [_tableSectionHeaderView addSubview:_desTitleLabel];
        [_desTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tableSectionHeaderView).offset(15);
            make.centerY.equalTo(_tableSectionHeaderView);
        }];
        
        UIView *bottomLineView = [[UIView alloc] init];
        bottomLineView.backgroundColor = sectionColor;
        [_tableSectionHeaderView addSubview:bottomLineView];
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_tableSectionHeaderView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _tableSectionHeaderView;
}

@end
