//
//  GGMarketViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/4/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMarketViewController.h"

#import "GGSetPayPasswordViewController.h"
#import "GGPaymentOrderRootViewController.h"
#import "GGOtherPayViewController.h"
#import "GGTransferEnterViewController.h"
#import "GGAttestationViewController.h"
#import "GGWalletViewController.h"
#import "GGCheckCarViewController.h"

#import "GGHomeTopView.h"
#import "GGMarketCollectionViewCell.h"
#import "GGMarketViewModel.h"

#import "Assess_RootViewController.h"
#import "CWTLimitStandardViewController.h"
#import "CWTSearchOffenceViewController.h"
#import "CWTVinSearchViewController.h"
#import "GGNewCarListViewController.h"

//#import "GGCarsListViewController.h"

@interface GGMarketViewController ()

@property(nonatomic,strong)GGHomeTopView *topView;
@property(nonatomic,strong)GGMarketViewModel *marketVM;
@property(nonatomic,strong)UIView *topContentView;
@property(nonatomic,assign)BOOL showAttestationOnFirst;

@end

@implementation GGMarketViewController

- (void)bindViewModel{
    
    [self.marketVM.updateCommand execute:nil];
    
    @weakify(self);

    //担保支付成功跳转
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:GGPaymentSuccessNotification object:nil]subscribeNext:^(id x) {
        @strongify(self);
        GGPaymentOrderRootViewController *orderVC = [[GGPaymentOrderRootViewController alloc] init];
        [self pushTo:orderVC];
    }];

    //代付成功
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:GGOtherPaySuccessNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        GGOtherPayViewController *otherPayVC = [[GGOtherPayViewController alloc] init];
        otherPayVC.value = @1;
        [self pushTo:otherPayVC];
    }];
    
    [RACObserve(self.marketVM, dataSource) subscribeCompleted:^{
        @strongify(self);
        [self.baseCollectionView reloadData];
    }];
    
    self.topView.click = ^(NSInteger tag){
        @strongify(self);
        
        if (![self checkRealNameAuthentication]) {
            [self showAttestationWthNoCheckView:YES];
            return;
        }

        switch (tag) {
            case 9:{
                GGTransferEnterViewController *transferVC = [[GGTransferEnterViewController alloc]init];
                transferVC.isTransfer = YES;
                [self pushTo:transferVC];
                [MobClick event:@"transfer"];
            }
                break;
            case 10:{
                GGWalletViewController *walletVC = [[GGWalletViewController alloc]init];
                [self pushTo:walletVC];
                [MobClick event:@"balance"];
            }
                break;
                
            default:{
                GGTransferEnterViewController *transferVC = [[GGTransferEnterViewController alloc]init];
                transferVC.isTransfer = NO;
                [self pushTo:transferVC];
                [MobClick event:@"paymentguarantee"];
            }
                break;
        }
    };
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:GGFirstGuideViewHiddenNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        if (self.isViewLoaded && self.view.window) {
            [self showTipView];
        }
    }];
}

- (void)setupView
{
    self.view.backgroundColor = tableBgColor;
    self.showAttestationOnFirst = YES;
    [self.topContentView addSubview:self.topView];
    
    [self.baseCollectionView registerClass:[GGMarketCollectionViewCell class]
                forCellWithReuseIdentifier:kCellIdentifierMarketCCell];
    self.baseCollectionView.scrollEnabled =  NO;
    
    [self.baseCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topContentView.mas_bottom);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(ceilf((self.view.width - 25) / 3 * 0.9) * 3 + 8);
    }];
}

#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.marketVM sectionCount];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.marketVM itemCountAtSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GGMarketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierMarketCCell forIndexPath:indexPath];
    cell.item = [self.marketVM itemForIndexPath:indexPath];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(-16, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GGMarketItem *item = [self.marketVM itemForIndexPath:indexPath];
    if (item.showNew && [item.title isEqualToString:@"V金融"]) {
        [self.marketVM setVBankDidClicked];
        item.showNew = NO;
    }
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    if (indexPath.item == 0) {
        [MobClick event:@"batch_of_car"];
        if (![self checkRealNameAuthentication]) {
            [self showAttestationWthNoCheckView:YES];
            return;
        }
        GGNewCarListViewController *newCarVC = [[GGNewCarListViewController alloc] init];
        [self pushTo:newCarVC];
    }else if (indexPath.item == 1){
        GGOtherPayViewController *payVC = [[GGOtherPayViewController alloc] init];
        [self pushTo:payVC];
    }else if (indexPath.item == 2) {
        GGCheckCarViewController *checkVC = [[GGCheckCarViewController alloc] init];
        [self pushTo:checkVC];
    }else if (indexPath.item == 3){
        [MobClick event:@"car_history"];
        if ([self checkRealNameAuthentication]) {
            CWTVinSearchViewController *vinVC = [[CWTVinSearchViewController alloc] init];
            vinVC.isMaintain = YES;
            [self pushTo:vinVC];
        } else {
            [self showAttestationWthNoCheckView:YES];
        }
    }else if (indexPath.item == 4) {
        Assess_RootViewController *assessVC = [[Assess_RootViewController alloc] init];
        [self pushTo:assessVC];
    }else if (indexPath.item == 5) {
        CWTLimitStandardViewController *standardVC = [[CWTLimitStandardViewController alloc] init];
        [self pushTo:standardVC];
    }else if (indexPath.item == 6) {
        CWTSearchOffenceViewController *searchVC = [[CWTSearchOffenceViewController alloc] init];
        [self pushTo:searchVC];
    }else if (indexPath.item == 7) {
        [MobClick event:@"vin_query"];
        if ([self checkRealNameAuthentication]) {
            CWTVinSearchViewController *vinVC = [[CWTVinSearchViewController alloc] init];
            [self pushTo:vinVC];
        } else {
            [self showAttestationWthNoCheckView:YES];
        }
    }else if (indexPath.item == 8){
        [MobClick event:@"v_finance"];
        GGWebViewController *webVC = [[GGWebViewController alloc] init];
        webVC.navigationItem.title = @"V金融";
        webVC.url = GGVBankUrl;
        [self pushTo:webVC];
    }
}

- (void)showAttestationWthNoCheckView:(BOOL)showNoCheckView
{
    GGAttestationViewController *vc = [[GGAttestationViewController alloc] init];
    vc.showNoCheckTipView = showNoCheckView;
    [self pushTo:vc];
}

- (void)showTipView{
    if ([GGLogin shareUser].user.auditingType == AuditingTypeNoSubmit && self.showAttestationOnFirst) {
        [self showAttestationWthNoCheckView:NO];
        self.showAttestationOnFirst = NO;
        return;
    }
}

#pragma mark - init view

- (UIView *)topContentView
{
    if (!_topContentView) {
        _topContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.width, 256)];
        _topContentView.backgroundColor = [UIColor clearColor];
        UIView *redBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _topContentView.width, 166)];
        redBgView.backgroundColor = themeColor;
    
        [_topContentView addSubview:redBgView];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_guan_icon"]];
        iconImageView.top = 54;
        iconImageView.centerX = _topContentView.centerX;
        
        [_topContentView addSubview:iconImageView];
    
        [self.view addSubview:_topContentView];
    }
    return _topContentView;
}

- (GGHomeTopView *)topView
{
    if (!_topView) {
        _topView = [[GGHomeTopView alloc]initWithFrame:CGRectMake(10, 106, self.topContentView.width - 20, 140)];
    }
    return _topView;
}

- (GGMarketViewModel *)marketVM
{
    if (!_marketVM) {
        _marketVM = [[GGMarketViewModel alloc] init];
    }
    return _marketVM;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.topView layoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showTipView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
