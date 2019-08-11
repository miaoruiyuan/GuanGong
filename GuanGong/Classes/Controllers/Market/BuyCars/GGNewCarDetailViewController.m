//
//  GGNewCarDetailViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/9.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGNewCarDetailViewController.h"

#import "GGVehicleInfoCell.h"
#import "GGNewCarGuaranteeCell.h"
#import "GGVehicleImagesCell.h"
#import "UINavigationBar+GGAwesome.h"

#import <SDCycleScrollView/SDCycleScrollView.h>

#import "GGNewCarDetailViewModel.h"

#import "GGNewCarOrderDetailViewController.h"
#import "GGCarOrderViewModel.h"
#import "GGCarOrderDetailRootViewController.h"
#import "GGShareCarViewController.h"
#import "TZPhotoBrowserController.h"

@interface GGNewCarDetailViewController ()<SDCycleScrollViewDelegate,PhotoBrowserDelegate>

@property(nonatomic,strong)UIImageView *noCarTipImageView;
@property(nonatomic,strong)SDCycleScrollView *carPhotoImageView;
@property(nonatomic,strong)UILabel *carPhotoCountLabel;

@property(nonatomic,strong)UIButton *buyButton;
@property(nonatomic,strong)UIButton *callPhoneBtn;

@property(nonatomic,strong)GGNewCarDetailViewModel *carDetailVM;
@property(nonatomic,strong)GGNewCarListModel *listModel;


@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *backButton;

@end

static const CGFloat NAVBAR_CHANGE_POINT = 50;

@implementation GGNewCarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithListModel:(GGNewCarListModel *)listModel
{
    self = [super init];
    if (self) {
        _listModel = listModel;
    }
    return self;
}

- (void)setupView
{
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.emptyDataTitle = @"无相关车辆信息";
    [self initNavItems];
    
    [self.baseTableView registerClass:[GGVehicleInfoCell class] forCellReuseIdentifier:kCellIdentifierVehicleInfo];
    
    [self.baseTableView registerClass:[GGNewCarGuaranteeCell class] forCellReuseIdentifier:kGGNewCarGuaranteeCellID];
    
    [self.baseTableView registerClass:[GGVehicleImagesCell class] forCellReuseIdentifier:kCellIdentifierVehicleImages];
    
    self.baseTableView.estimatedRowHeight = 40;
    
    [self.view addSubview:self.callPhoneBtn];
    [self.callPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self.view);
        make.height.mas_equalTo(48);
        make.width.equalTo(self.view).offset(-120);
    }];
    
    [self.view addSubview:self.buyButton];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(120, 48));
    }];
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(-64);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.buyButton.mas_top);
    }];
    
    self.baseTableView.hidden = YES;
}

- (void)initNavItems
{
    @weakify(self);
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, 0, 31, 31);
    [self.backButton setImage:[UIImage imageNamed:@"nav_back_btn_h"] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];;
    self.navigationItem.leftBarButtonItem = backItem;
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.frame = CGRectMake(0, 0, 31, 31);
    [self.shareButton setImage:[UIImage imageNamed:@"nav_right_share_btn_h"] forState:UIControlStateNormal];
    [[self.shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        GGShareCarViewController *shareVC = [[GGShareCarViewController alloc] initWithNewCarDetailModel:self.carDetailVM.carDetailModel];
        [[self class] presentVC:shareVC];
        [MobClick event:@"car_share"];
    }];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    self.navigationItem.rightBarButtonItems = @[shareItem];
}

- (void)setTopButtonWhite:(BOOL)isWhite
{
    if (isWhite) {
        [self.shareButton setImage:[UIImage imageNamed:@"nav_right_share_btn_n"] forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage imageNamed:@"nav_back_btn_n"] forState:UIControlStateNormal];
    }else{
        [self.shareButton setImage:[UIImage imageNamed:@"nav_right_share_btn_h"] forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage imageNamed:@"nav_back_btn_h"] forState:UIControlStateNormal];
    }
}

- (void)bindViewModel
{
    self.carDetailVM = [[GGNewCarDetailViewModel alloc] init];
    
    [self getCarDetail];
    
    @weakify(self);
    [[self.buyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [MobClick event:@"buy_newcar"];
        if (self.carDetailVM.carDetailModel.isCreateOrder == 0) {
            [MBProgressHUD showError:self.carDetailVM.carDetailModel.unCreateOrderRemark];
            return;
        }
        
        GGNewCarOrderDetailViewController *orderDetailVC = [[GGNewCarOrderDetailViewController alloc] initWithNewCarDetail:self.carDetailVM.carDetailModel];
        [orderDetailVC setPopHandler:^(NSString *orderNo){
            [self goToCarOrderDetailVC:orderNo];
        }];
        [self pushTo:orderDetailVC];
    }];
}

- (void)getCarDetail
{
    [MBProgressHUD showMessage:@"请稍侯..." toView:self.view];
    @weakify(self);
    [[self.carDetailVM.carDetailCommand execute:self.listModel.carId] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.baseTableView.hidden = NO;
        self.carPhotoImageView.imageURLStringsGroup = self.carDetailVM.carDetailModel.photosList;
        self.baseTableView.tableHeaderView = self.carPhotoImageView;
        [self.baseTableView reloadData];
        [self setCarStatusView];
    } error:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)setCarStatusView
{
    [self setCurrentCarPhotoIndex:0];
    
    GGNewCarWareStockModel *stockModel = self.carDetailVM.carDetailModel.wareStockResponse;
    if (stockModel.stock > 0) {
        self.noCarTipImageView.hidden = YES;
        self.buyButton.enabled = YES;
    }else{
        self.buyButton.enabled = NO;
        self.noCarTipImageView.hidden = NO;
    }
    
    if (self.carDetailVM.carDetailModel.status != 3) {
        self.buyButton.enabled = NO;
        self.noCarTipImageView.hidden = NO;
        self.noCarTipImageView.image = [UIImage imageNamed:@"buy_new_car_icon_xiajia"];
    }
}

- (void)setCurrentCarPhotoIndex:(NSInteger)index
{
    self.carPhotoCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",index + 1,(unsigned long)self.carPhotoImageView.imageURLStringsGroup.count];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return self.carDetailVM.carDetailModel.photosList.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GGVehicleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierVehicleInfo];
        [cell updateUIWithModel:self.carDetailVM.carDetailModel];
        return cell;
    }else if(indexPath.section == 1){
        GGNewCarGuaranteeCell *cell = [tableView dequeueReusableCellWithIdentifier:kGGNewCarGuaranteeCellID];
        [cell showWithTagArray:self.carDetailVM.carDetailModel.serviceTags];
        return cell;
    }else if(indexPath.section == 2){
        GGVehicleImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierVehicleImages];
        cell.url = self.carDetailVM.carDetailModel.photosList[indexPath.row];
        return cell;
    }
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    } else if (indexPath.section == 1){
        return [GGNewCarGuaranteeCell getCellHight:self.carDetailVM.carDetailModel.serviceTags];
    } else if (indexPath.section == 2){
        return (kScreenWidth - 24) * .75;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2 || section == 0) {
        return 0.01f;
    }
    return 10;
}

#pragma mark - Change Nav

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.baseTableView.delegate = self;
    [self scrollViewDidScroll:self.baseTableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.baseTableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor *color = [UIColor colorWithWhite:1.0 alpha:1.0];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        self.navigationItem.title = self.carDetailVM.carDetailModel.titleS;
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self setTopButtonWhite:NO];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        self.navigationItem.title = @"";
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setTopButtonWhite:YES];
    }
}

- (void)goToCarOrderDetailVC:(NSString *)orderNo
{
    [MBProgressHUD showMessage:@"获取订单详情" toView:self.view];
    GGCarOrderDetail *orderDetail = [[GGCarOrderDetail alloc] init];
    orderDetail.orderNo = orderNo;
    
    GGCarOrderViewModel *orederVM = [[GGCarOrderViewModel alloc] init];
    orederVM.orderDetail = orderDetail;
    @weakify(self);
    [[orederVM.orderDetailCommand execute:nil] subscribeError:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
    } completed:^{
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
        GGCarOrderDetailRootViewController *orderDetailVC = [[GGCarOrderDetailRootViewController alloc] init];
        orderDetailVC.orderDetail = orederVM.orderDetail;
        [self pushTo:orderDetailVC];
        [self getCarDetail];
    }];
}

#pragma mark - init View

- (SDCycleScrollView *)carPhotoImageView
{
    if (!_carPhotoImageView) {
        _carPhotoImageView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * .75) delegate:self placeholderImage:[UIImage imageNamed:@"car_detail_image_failed"]];
        _carPhotoImageView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _carPhotoImageView.autoScroll = NO;
        _carPhotoImageView.showPageControl = NO;

        _noCarTipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buy_new_car_listNoCount"]];
        [_carPhotoImageView addSubview:_noCarTipImageView];
        [_noCarTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_carPhotoImageView);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        _noCarTipImageView.hidden = YES;

        _carPhotoCountLabel = [[UILabel alloc] init];
        _carPhotoCountLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];
        _carPhotoCountLabel.font = [UIFont systemFontOfSize:13];
        _carPhotoCountLabel.textColor = [UIColor whiteColor];
        _carPhotoCountLabel.textAlignment = NSTextAlignmentCenter;
        [_carPhotoImageView addSubview:_carPhotoCountLabel];
        [_carPhotoCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(_carPhotoImageView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(46, 24));
        }];
    }
    return _carPhotoImageView;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    TZPhotoBrowserController *photosBrowser = [[TZPhotoBrowserController alloc] init];
    photosBrowser.delegate = self;
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:self.carDetailVM.carDetailModel.photosList.count];
    for (NSString *url in self.carDetailVM.carDetailModel.photosList) {
        CarScrollImageModel *model = [[CarScrollImageModel alloc] init];
        model.url = url;
        [imageArray addObject:model];
    }
    
    photosBrowser.imageArr = imageArray;
    photosBrowser.selectedIndex = index;
    photosBrowser.titleStr = self.carDetailVM.carDetailModel.titleL;
    photosBrowser.originalRect = [self.carPhotoImageView convertRect:self.carPhotoImageView.frame toView:self.baseTableView];
    
    [self presentViewController:photosBrowser animated:NO completion:nil];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    [self setCurrentCarPhotoIndex:index];
}

#pragma mark - PhotoBrowserDelegate

- (void)dismissViewWithTurnToIndex:(NSInteger)index
{
    
}

- (UIButton *)callPhoneBtn
{
    if (!_callPhoneBtn) {
        _callPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callPhoneBtn setTitle:@"  电话咨询" forState:UIControlStateNormal];
        [_callPhoneBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_callPhoneBtn setImage:[UIImage imageNamed:@"car_detail_call_phone"]  forState:UIControlStateNormal];
        [_callPhoneBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_callPhoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        @weakify(self);
        [[_callPhoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            NSString *str = [[NSString alloc] initWithFormat:@"tel:%@",self.carDetailVM.carDetailModel.contactsPhone];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }];
    }
    return _callPhoneBtn;
}

- (UIButton *)buyButton
{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buyButton.titleLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
        [_buyButton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyButton setBackgroundImage:[UIImage imageWithColor:textLightColor] forState:UIControlStateDisabled];
    }
    return _buyButton;
}

@end
