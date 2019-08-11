//
//  GGNewCarListViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/9.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGNewCarListViewController.h"
#import "GGNewCarListCell.h"
#import "GGNewCarListViewModel.h"
#import "GGNewCarListAlertView.h"
#import "GGLocationViewController.h"
#import "GGNewCarDetailViewController.h"
#import "GGUserInfoViewModel.h"

@interface GGNewCarListViewController ()

@property (nonatomic,strong)GGNewCarListViewModel *carListVM;

@end

@implementation GGNewCarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView
{
    self.navigationItem.title = @"好车抢购";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"抢购规则" style:UIBarButtonItemStylePlain handler:^(UIBarButtonItem *sender) {
        [GGNewCarListAlertView showContent:[GGNewCarListAlertView getDefaultContent] andBlock:nil];
    }];
    
    self.style = UITableViewStylePlain;
    
    [self.baseTableView registerClass:[GGNewCarListCell class] forCellReuseIdentifier:kGGNewCarListCellID];
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    

    self.emptyDataMessage = @"好车已经被抢光啦！\n\n敬请期待下次上新！";
    
//    self.emptyDataMessage = @"";
    self.baseTableView.estimatedRowHeight = kScreenWidth * 0.5 + 30;
    self.baseTableView.rowHeight = UITableViewAutomaticDimension;
    self.enabledRefreshHeader = YES;
    self.enabledRefreshFooter = YES;
}

- (void)bindViewModel
{
    self.carListVM = [[GGNewCarListViewModel alloc] init];
    
    @weakify(self);
    [[self.carListVM.loadData.executing skip:1] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.emptyDataDisplay = !x.boolValue;
        if (!x.boolValue) {
            [self.baseTableView reloadData];
        }
    }];
    [self beginHeaderRefreshing];
}

#pragma mark - TableView Refresh

- (void)refreshHeaderAction{
    [self refresh];
}

- (void)refreshFooterAction{
    [self refreshMore];
}

- (void)refresh{
    if (self.carListVM.isLoading) {
        return;
    }
    self.carListVM.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshMore{
    if (self.carListVM.isLoading || !self.carListVM.canLoadMore) {
        [self footerEndNoMoreData];
        return;
    }
    self.carListVM.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest{
    @weakify(self);
    [[self.carListVM.loadData execute:nil] subscribeError:^(NSError *error) {
        @strongify(self);
        [self endRefreshHeader];
        [self endRefreshFooter];
    } completed:^{
        @strongify(self);
        [self endRefreshHeader];
        [self endRefreshFooter];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.carListVM itemCountAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGNewCarListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGGNewCarListCellID];
    if (cell) {
        GGNewCarListModel *model = [self.carListVM itemForIndexPath:indexPath];
        [cell updateUIWithModel:model];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GGNewCarListModel *model = [self.carListVM itemForIndexPath:indexPath];
    GGNewCarDetailViewController *detailVC = [[GGNewCarDetailViewController alloc] initWithListModel:model];
    [self pushTo:detailVC];
    [MobClick event:@"car_details"];
}


- (BOOL)showChooseCityView
{
    if ((self.carListVM.cityID && self.carListVM.provinceID) || ([GGLogin shareUser].user.cityId  && [GGLogin shareUser].user.cityId)) {
        return NO;
    }
    return YES;
}

#pragma mark - 

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_newCar_empty_icon"];
}

#pragma mark - DZNEmptyDataSetSource

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if (![self showChooseCityView]) {
        return nil;
    }
    UIView *emptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.height, scrollView.height)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_newCar_empty_icon"]];
    
    [emptView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptView);
        make.centerY.equalTo(emptView).offset(-20);
    }];
        
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.cornerRadius = 2;
    
    [sendBtn.layer setBorderWidth:0.5f]; //边框宽度
    [sendBtn.layer setBorderColor:[UIColor colorWithHexString:@"939393"].CGColor];
    
    if (self.carListVM.location) {
        [sendBtn setTitle:self.carListVM.location forState:UIControlStateNormal];
    }else{
        [sendBtn setTitle:@"请选择经营所在地" forState:UIControlStateNormal];
    }
    [sendBtn setImage:[UIImage imageNamed:@"arrow_right_small"] forState:UIControlStateNormal];

    sendBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [sendBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [sendBtn putImageOnTheRightSideOfTitle];

    [emptView addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptView);
        make.top.equalTo(imageView.mas_bottom).offset(24);
        make.size.mas_equalTo(CGSizeMake(150, 28));
    }];
    
    [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        GGFormItem *item = [[GGFormItem alloc] init];
        GGLocationViewController *cityVC = [[GGLocationViewController alloc] initWithItem:item];
        @weakify(cityVC);
        [cityVC setPopHandler:^(GGFormItem *item){
            NSString *location = [item.obj valueForKey:@"location"];
            NSString *cityID = [[item.obj valueForKey:@"cityId"] stringValue];
            NSString *provinceID = [[item.obj valueForKey:@"provinceId"] stringValue];
            self.carListVM.cityID = cityID;
            self.carListVM.provinceID = provinceID;
            self.carListVM.location = location;
            [self updateUserLocation:item];
            [sender setTitle:location forState:UIControlStateNormal];
            [sender putImageOnTheRightSideOfTitle];
            @strongify(cityVC);
            [cityVC dismiss];
            [self beginHeaderRefreshing];
        }];
        [GGBaseViewController presentVC:cityVC];
    }];
    
    return emptView;
}

- (void)updateUserLocation:(GGFormItem *)item
{
    GGUserInfoViewModel *userInfoVM = [[GGUserInfoViewModel alloc] init];
    [[userInfoVM editCommand] execute:item];
}

@end
