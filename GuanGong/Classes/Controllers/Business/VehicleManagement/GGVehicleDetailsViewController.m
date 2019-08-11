//
//  GGVehicleDetailsViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGVehicleDetailsViewController.h"

#import "GGActionSheet.h"

#import "GGVehicleInfoCell.h"
#import "GGVehicleOwnerCell.h"
#import "GGVehicleImagesCell.h"
#import "GGVehicleWarrantyCell.h"
#import "UINavigationBar+GGAwesome.h"

#import "GGVehicleMagmentViewModel.h"

#import <SDCycleScrollView/SDCycleScrollView.h>

#import "GGFriendInfoViewController.h"
#import "GGCreateCarViewController.h"
#import "GGWarrantCarViewController.h"
#import "GGPlaceOrderDetailViewController.h"

@interface GGVehicleDetailsViewController ()

@property(nonatomic,strong)GGVehicleMagmentViewModel *vehicleManagerVM;
@property(nonatomic,strong)GGVehicleList *listCar;

@property(nonatomic,strong)SDCycleScrollView *carPhotoImageView;
@property(nonatomic,strong)UILabel *reviewStatusLabel;

@property(nonatomic,strong)UIButton *moreButton;


@property(nonatomic,strong)UIButton *buyButton;
@property(nonatomic,strong)UIButton *callPhoneBtn;

@end

static const CGFloat NAVBAR_CHANGE_POINT = 50;

@implementation GGVehicleDetailsViewController{
    NSInteger sectionCount;
}

- (id)initWithItem:(GGVehicleList *)car{
    if (self = [super init]) {
        self.listCar = car;
        _isMyVehicle = NO;
    }
    return self;
}

- (void)bindViewModel
{
    @weakify(self);
    [[self.vehicleManagerVM.carDetailsCommand execute:self.listCar.carId] subscribeCompleted:^{
        @strongify(self);
        
        self.baseTableView.tableHeaderView = self.carPhotoImageView;
        GGCar *_car = self.vehicleManagerVM.car;
        if (_car.photosList.count > 0) {
            self.carPhotoImageView.imageURLStringsGroup = _car.photosList;
            [self showCarStatus:_car];
        }
        [self showRightButton:_car];
        [self setTableSectionCount:_car];
        [self.baseTableView reloadData];
    }];

    [[self.vehicleManagerVM.carDetailsCommand.executing skip:1] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }else{
            [MBProgressHUD hideHUDForView:self.view];
        }
    }];
}

- (void)showCarStatus:(GGCar *)car
{
    if (car.status == 2 || car.status == 3 || car.status == 8
        || car.status == 9 || car.status == 10) {
        if (car.status == 3) {
            self.reviewStatusLabel.backgroundColor = [UIColor colorWithRed:230.0/255 green:76.0/255 blue:78.0/255 alpha:0.6f];
            self.reviewStatusLabel.text = [NSString stringWithFormat:@"审核未过原因：%@",car.auditDescription];
        } else {
            self.reviewStatusLabel.text = car.statusName;
            self.reviewStatusLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
        }
        self.reviewStatusLabel.hidden = NO;
        self.carPhotoImageView.showPageControl = NO;
    } else {
        self.reviewStatusLabel.hidden = YES;
        self.carPhotoImageView.showPageControl = YES;
    }
    
    if (!_isMyVehicle) {
        if ([car.user.userId isEqualToNumber:[GGLogin shareUser].user.userId]) {
            self.buyButton.enabled = NO;
            [self bk_performBlock:^(UIViewController *obj) {
                [MBProgressHUD showSuccess:@"此为自己售卖的车" toView:obj.view];
            } afterDelay:0.3f];
        }
    }
}

- (void)showRightButton:(GGCar *)car
{
    if (_isMyVehicle) {
        if (car.status == 2 || car.status == 3 || car.status == 8
            || car.status == 9 || car.status == 10 || car.status == 5) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreButton];
        }
    }
}

- (void)setTableSectionCount:(GGCar *)car
{
    if (car.status == 5 || car.status == 6) {
        sectionCount = 4;
    }else{
        sectionCount = 3;
    }
}

- (void)setupView
{
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.emptyDataTitle = @"无相关车辆信息";
    [self.baseTableView registerClass:[GGVehicleInfoCell class] forCellReuseIdentifier:kCellIdentifierVehicleInfo];
    [self.baseTableView registerClass:[GGVehicleWarrantyCell class] forCellReuseIdentifier:kGGVehicleWarrantyCellID];
    [self.baseTableView registerClass:[GGVehicleOwnerCell class] forCellReuseIdentifier:kCellIdentifierVehicleOwner];
    [self.baseTableView registerClass:[GGVehicleImagesCell class] forCellReuseIdentifier:kCellIdentifierVehicleImages];

    if (_isMyVehicle) {
        [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(-64, 0, 0, 0));
        }];
        self.buyButton.enabled = NO;
    } else {
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
    }
    
    //点击购买
    [[self.buyButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        GGPlaceOrderDetailViewController *orderDetailVC = [[GGPlaceOrderDetailViewController alloc] initWithCarInfo:self.vehicleManagerVM.car];
        [self pushTo:orderDetailVC];
    }];
}

#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == (sectionCount - 1)) {
        return self.vehicleManagerVM.car.photosList.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GGVehicleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierVehicleInfo];
        cell.car = self.vehicleManagerVM.car;
        return cell;
    }else if(sectionCount == 4 && indexPath.section == 1){
        GGVehicleWarrantyCell *cell = [tableView dequeueReusableCellWithIdentifier:kGGVehicleWarrantyCellID];
        [cell updateUIWithStatus:self.vehicleManagerVM.car.hasApplyCheckOrder];
        [[[cell.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            GGWarrantCarViewController *carVC = [[GGWarrantCarViewController alloc] initWithCarModel:self.vehicleManagerVM.car];
            [self pushTo:carVC];
        }];
        return cell;
    }else if (indexPath.section == sectionCount - 2){
        GGVehicleOwnerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierVehicleOwner];
        cell.info = self.vehicleManagerVM.car.user;
        return cell;
    }else{
        GGVehicleImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierVehicleImages];
        cell.url = self.vehicleManagerVM.car.photosList[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:kCellIdentifierVehicleInfo
                                        cacheByIndexPath:indexPath
                                           configuration:^(GGVehicleInfoCell *cell) {
                                               cell.car = self.vehicleManagerVM.car;
                                           }];
    } else if (sectionCount == 4 && indexPath.section == 1){
        return 133;
    } else if (indexPath.section == sectionCount - 2){
        return 70;
    } else {
        return (kScreenWidth - 24) * .75;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == (sectionCount - 1)) {
        return 0.01;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == sectionCount - 2) {
        GGFriendInfoViewController *friendVC = [[GGFriendInfoViewController alloc] init];
        friendVC.dealerId = self.vehicleManagerVM.car.user.userId;
        [self pushTo:friendVC];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UINavigation Bar Change 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor *color = [UIColor colorWithWhite:1.0 alpha:1.0];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        _moreButton.highlighted = YES;
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.title = self.vehicleManagerVM.car.titleS;
    } else {
        self.navigationItem.title = @"";
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        _moreButton.highlighted = NO;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - 删除该车
- (void)deleteCar{
    @weakify(self);
    [UIAlertController alertInController:self
                                   title:@"删除该车辆?"
                                 message:nil
                              confrimBtn:@"确定删除"
                            confrimStyle:UIAlertActionStyleDestructive
                           confrimAction:^{
                               @strongify(self);
                               [[self.vehicleManagerVM.deleteCommand execute:self.vehicleManagerVM.car.carId]subscribeCompleted:^{
                                   [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
                                   [self bk_performBlock:^(GGVehicleDetailsViewController  *vc) {
                                       if (vc.popHandler) {
                                           vc.popHandler(@"DeleteCar");
                                       }
                                       [vc pop];
                                   } afterDelay:1.2];
                               }];
                           }
                               cancelBtn:@"取消"
                             cancelStyle:UIAlertActionStyleCancel
                            cancelAction:^{}];
}

#pragma mark - 车辆编辑
- (void)editCar{
    GGCreateCarViewController *creatVC = [[GGCreateCarViewController alloc] initWithObject:self.vehicleManagerVM.car];
    [[self class] presentVC:creatVC];
}

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

- (SDCycleScrollView *)carPhotoImageView
{
    if (!_carPhotoImageView) {
        _carPhotoImageView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * .75) delegate:nil placeholderImage:[UIImage imageNamed:@"car_detail_image_failed"]];
        _carPhotoImageView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        [_carPhotoImageView addSubview:self.reviewStatusLabel];
        [self.reviewStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_carPhotoImageView);
            make.height.mas_equalTo(32);
        }];
    }
    return _carPhotoImageView;
}

- (UILabel *)reviewStatusLabel{
    if (!_reviewStatusLabel) {
        _reviewStatusLabel = [UILabel new];
        _reviewStatusLabel.font = [UIFont systemFontOfSize:15];
        _reviewStatusLabel.textColor = [UIColor whiteColor];
        _reviewStatusLabel.textAlignment = NSTextAlignmentCenter;
        _reviewStatusLabel.hidden = YES;
    }
    return _reviewStatusLabel;
}

- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(0, 0, 30, 30);
        [_moreButton setImage:[UIImage imageNamed:@"detail_more_circle"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"detail_more_normal"] forState:UIControlStateHighlighted];
        [[_moreButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            GGActionSheet *sheet = [[GGActionSheet alloc] initWithTitle:nil
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:@"删除"
                                                      otherButtonTitles:@[@"编辑车辆"]
                                                       actionSheetBlock:^(NSInteger buttonIndex) {
                                                           
                                                           if (buttonIndex == 0) {
                                                               [self deleteCar];
                                                           }else if (buttonIndex == 1){
                                                               [self editCar];
                                                           }
                                                       }];
            
            [sheet show];
        }];
    }
    return _moreButton;
}

- (GGVehicleMagmentViewModel *)vehicleManagerVM{
    if (!_vehicleManagerVM) {
        _vehicleManagerVM = [[GGVehicleMagmentViewModel alloc] init];
    }
    return _vehicleManagerVM;
}

- (UIButton *)callPhoneBtn
{
    if (!_callPhoneBtn) {
        _callPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callPhoneBtn setTitle:@"  电话咨询" forState:UIControlStateNormal];
        [_callPhoneBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_callPhoneBtn setImage:[UIImage imageNamed:@"car_detail_call_phone"]  forState:UIControlStateNormal];
        [_callPhoneBtn setBackgroundImage:[UIImage imageWithColor:tableBgColor] forState:UIControlStateNormal];
        [_callPhoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [[_callPhoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            NSString *str = [[NSString alloc] initWithFormat:@"tel:%@",self.vehicleManagerVM.car.user.mobile];
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
    }
    return _buyButton;
}

@end
