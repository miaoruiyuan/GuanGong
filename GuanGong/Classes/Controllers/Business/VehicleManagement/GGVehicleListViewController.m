//
//  GGVehicleListViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/3.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGVehicleListViewController.h"
#import "GGVehicleDetailsViewController.h"
#import "GGVehicleListCell.h"
#import "GGVehicleMagmentViewModel.h"
#import "GGCreateCarViewController.h"

@interface GGVehicleListViewController ()

@property(nonatomic,strong)GGVehicleMagmentViewModel *vehicleManagerVM;

@end

@implementation GGVehicleListViewController

- (void)bindViewModel{
    
    @weakify(self);
    [[self.vehicleManagerVM.loadData.executing skip:1] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.emptyDataDisplay = !x.boolValue;
    }];
    
}
- (void)setupView{
    self.style = UITableViewStylePlain;
    self.emptyDataTitle = @"暂无相关车车辆";
    [self.baseTableView registerClass:[GGVehicleListCell class] forCellReuseIdentifier:kCellIdentifierVehicleList];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.enabledRefreshHeader = YES;
    self.enabledRefreshFooter = YES;
    [self beginHeaderRefreshing];
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
    [[self.vehicleManagerVM.loadData execute:@(self.listType)]subscribeError:^(NSError *error) {
        @strongify(self);
        [self endRefreshHeader];
        [self endRefreshFooter];
    } completed:^{
        @strongify(self);
        [self endRefreshHeader];
        [self endRefreshFooter];
        [self.baseTableView reloadData];
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
    GGVehicleListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierVehicleList];
    cell.car = self.vehicleManagerVM.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:12 hasSectionLine:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGVehicleDetailsViewController *vc = [[GGVehicleDetailsViewController alloc] initWithItem:self.vehicleManagerVM.dataSource[indexPath.row]];
    vc.isMyVehicle = YES;
    vc.popHandler = ^(id value) {
        [self beginHeaderRefreshing];
    };
    [self pushTo:vc];
    
}

- (GGVehicleMagmentViewModel *)vehicleManagerVM{
    if (!_vehicleManagerVM) {
        _vehicleManagerVM = [[GGVehicleMagmentViewModel alloc] init];
        _vehicleManagerVM.isCarsList = NO;
    }
    return _vehicleManagerVM;
}

#pragma mark - DZNEmptyDataSetSource

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    UIView *emptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.height, scrollView.height)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empt_image_no_car"]];
    
    [emptView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptView);
        make.centerY.equalTo(emptView).offset(-80);
    }];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = self.emptyDataTitle;
    messageLabel.textColor = [UIColor lightGrayColor];
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [emptView addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(emptView);
        make.centerX.equalTo(emptView);
        make.centerY.equalTo(emptView);
    }];
    
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.cornerRadius = 2;

    [sendBtn.layer setBorderWidth:0.5f]; //边框宽度
    [sendBtn.layer setBorderColor:textLightColor.CGColor];
    
    [sendBtn setTitle:@"立即发布" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [sendBtn setTitleColor:textNormalColor forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [emptView addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptView);
        make.centerY.equalTo(emptView).offset(50);
        make.size.mas_equalTo(CGSizeMake(90, 28));
    }];
    
    [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        GGCreateCarViewController *creatVC = [[GGCreateCarViewController alloc] init];
        [GGBaseViewController presentVC:creatVC];
    }];
    
    return emptView;
}

@end
