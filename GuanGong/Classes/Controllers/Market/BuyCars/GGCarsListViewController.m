//
//  GGCarsListViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/18.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarsListViewController.h"
#import "GGVehicleDetailsViewController.h"
#import "GGLocationViewController.h"
#import "GGCarModelViewController.h"
#import "GGPriceViewController.h"
#import "GGSortViewController.h"
#import "YZPullDownMenu.h"
#import "GGMenuButton.h"
#import "UIView+Toast.h"
#import "GGVehicleMagmentViewModel.h"
#import "GGCarsListCell.h"
#import "GGNavigationBottomTipView.h"

@interface GGCarsListViewController ()<YZPullDownMenuDataSource>

@property(nonatomic,strong)NSMutableArray *menuTitles;

@property(nonatomic,strong)GGVehicleMagmentViewModel *vehicleManagerVM;

@property(nonatomic,strong)YZPullDownMenu *pullDownMenu;

@end

@implementation GGCarsListViewController

- (void)bindViewModel{
    @weakify(self);
    [[self.vehicleManagerVM.loadData.executing skip:1] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.emptyDataDisplay = !x.boolValue;
        if (!x.boolValue) {
            [self.baseTableView reloadData];
            [self showCarListCount:[self.vehicleManagerVM.totalCount integerValue]];
        }
    }];
    
    //监听通知
    [[RACObserve(self.vehicleManagerVM, notification) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        [self beginHeaderRefreshing];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:YZUpdateMenuTitleNote object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        
        NSInteger selectedIndex = [self.childViewControllers indexOfObject:note.object];
        NSArray *allValues = note.userInfo.allValues;
        if (allValues.count > 1 || [allValues.firstObject isKindOfClass:[NSArray class]]){
            return;
        }
        self.menuTitles[selectedIndex] = allValues.firstObject;
    }];
}

#pragma mark- 数量提示
- (void)showCarListCount:(NSInteger )count
{
    NSString *text;
    if (count > 0) {
        text = [NSString stringWithFormat:@"共找到%ld辆车",(long)count];
    } else {
        text = @"暂无相关数据";
    }
    if (!self.vehicleManagerVM.willLoadMore) {
        [GGNavigationBottomTipView showInNavigation:self.navigationController message:text];
    }
}

- (void)setupView{
    self.navigationItem.title = @"买车";
    _pullDownMenu = [[YZPullDownMenu alloc] init];
    _pullDownMenu.dataSource = self;
    [self.view addSubview:_pullDownMenu];
    [_pullDownMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(64);
        make.height.mas_equalTo(42);
    }];
    
    self.style = UITableViewStylePlain;
    self.emptyDataTitle = @"暂无相关车源";
    [self.baseTableView registerClass:[GGCarsListCell class] forCellReuseIdentifier:kCellIdentifierCarsList];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pullDownMenu.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.enabledRefreshHeader = YES;
    self.enabledRefreshFooter = YES;
    [self beginHeaderRefreshing];
    
    
    _menuTitles = [@[@"地区",@"品牌",@"价格",@"排序"] mutableCopy];
    [self setupAllChildViewController];
    
    
//    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemSearch handler:^(id sender) {
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"%@",_menuTitles);
}

#pragma amrk - 添加子控制器
- (void)setupAllChildViewController{

    GGLocationViewController *locationVC = [[GGLocationViewController alloc] init];
    GGCarModelViewController *modelVC = [[GGCarModelViewController alloc] init];
    GGPriceViewController *priceVC = [[GGPriceViewController alloc] init];
    GGSortViewController *sortVC = [[GGSortViewController alloc] init];
    
    locationVC.isCarsList = YES;
    modelVC.isCarsList = YES;
    
    [self addChildViewController:locationVC];
    [self addChildViewController:modelVC];
    [self addChildViewController:priceVC];
    [self addChildViewController:sortVC];
}


- (void)refreshHeaderAction{
    [self refresh];
}

- (void)refreshFooterAction{
    [self refreshMore];
}

- (void)refresh{
    if (self.vehicleManagerVM.isLoading) {
        return;
    }
    self.vehicleManagerVM.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshMore{
    if (self.vehicleManagerVM.isLoading || !self.vehicleManagerVM.canLoadMore) {
        [self footerEndNoMoreData];
        return;
    }
    self.vehicleManagerVM.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest{
    @weakify(self);
    [[self.vehicleManagerVM.loadData execute:nil]subscribeError:^(NSError *error) {
        @strongify(self);
        [self endRefreshHeader];
        [self endRefreshFooter];
    } completed:^{
        @strongify(self);
        [self endRefreshHeader];
        [self endRefreshFooter];
    }];
}

#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = self.vehicleManagerVM.dataSource.count;
    tableView.mj_footer.hidden = count > 6 ? NO : YES;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGCarsListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCarsList];
    cell.car = self.vehicleManagerVM.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:12 hasSectionLine:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 99;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGVehicleDetailsViewController *detailsVC = [[GGVehicleDetailsViewController alloc] initWithItem:self.vehicleManagerVM.dataSource[indexPath.row]];
    [self pushTo:detailsVC];
}


#pragma mark- YZPullDownMenuDataSource
- (NSInteger)numberOfColsInMenu:(YZPullDownMenu *)pullDownMenu{
    return _menuTitles.count;
}

- (UIButton *)pullDownMenu:(YZPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:_menuTitles[index] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    
    return button;
}

- (UIViewController *)pullDownMenu:(YZPullDownMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index{
    return self.childViewControllers[index];
}


- (CGFloat)pullDownMenu:(YZPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
            return kScreenHeight - 106;
            break;
            
        case 1:
            return kScreenHeight - 106;
            break;
            
        case 2:
            return 10 * 52;
            break;
            
        default:
            return 6 * 52;
            break;
    }
    
}

- (GGVehicleMagmentViewModel *)vehicleManagerVM{
    if (!_vehicleManagerVM) {
        _vehicleManagerVM = [[GGVehicleMagmentViewModel alloc] init];
        _vehicleManagerVM.isCarsList = YES;
    }
    return _vehicleManagerVM;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
