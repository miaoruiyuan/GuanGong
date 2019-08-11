//
//  CWTAssessHistoryViewController.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/5/3.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTAssessHistoryViewController.h"
#import "CWTAssessmentResultViewController.h"
#import "CWTAssessHistoryCell.h"

#import "AssessHistoryViewModel.h"

@interface CWTAssessHistoryViewController ()

@property(nonatomic,strong)AssessHistoryViewModel *assessVm;

@end

@implementation CWTAssessHistoryViewController

- (AssessHistoryViewModel *)assessVm{
    if (!_assessVm) {
        _assessVm = [[AssessHistoryViewModel alloc] init];
    }
    return _assessVm;
}

-(void)viewDidLoad
{
    self.style = UITableViewStyleGrouped;
    [super viewDidLoad];
//    [self.refreshFooter setTitle:@"没有更多记录了" forState:MJRefreshStateNoMoreData];
    [self setupView];
    [self bindViewModel];
}

- (void)setupView{
    
    self.enabledRefreshHeader  = YES;
    self.enabledRefreshFooter = YES;
    self.emptyDataMessage = @"一条记录都没有";
//    self.emptyDataButtonTitle = @"去估值";


    self.navigationItem.title = @"评估历史";
    
    [self.baseTableView registerClass:[CWTAssessHistoryCell class] forCellReuseIdentifier:kCellIdentifierAssessHistory];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self beginHeaderRefreshing];
    
}

- (void)bindViewModel{
    @weakify(self);
    [RACObserve(self.assessVm, totalCount)subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.intValue > 0) {
            self.navigationItem.title = [NSString stringWithFormat:@"评估历史 (%@)",x];
        }
        
    }];
}


- (void)refreshHeaderAction{
    [super refreshHeaderAction];
    [self refresh];
}

- (void)refreshFooterAction{
    [super refreshFooterAction];
    [self refreshMore];
}

- (void)refresh{
    if (self.assessVm.isLoading) {
        return;
    }
    self.assessVm.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshMore{
    if (self.assessVm.isLoading || !self.assessVm.canLoadMore) {
        [self footerEndNoMoreData];
        return;
    }
    self.assessVm.willLoadMore = YES;
    
    [self sendRequest];
}

- (void)sendRequest{
    @weakify(self);
    [[self.assessVm.historyCommand.executing skip:1]subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (!x.boolValue) {
            [self endRefreshHeader];
            [self endRefreshFooter];
            [self.baseTableView reloadData];
            
            if (self.assessVm.dataSource.count > 0) {
                self.emptyDataDisplay = NO;
            }else{
                self.emptyDataDisplay = YES;
            }
        }else{
            
        }
    }];
    
    [self.assessVm.historyCommand execute:nil];
    
}


#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = self.assessVm.dataSource.count;
    tableView.mj_footer.hidden = count > 6 ? NO : YES;
//    tableView.mj_footer.hidden = YES;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CWTAssessHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierAssessHistory];
    [cell configItemWithObj:self.assessVm.dataSource[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:kCellIdentifierAssessHistory configuration:^(CWTAssessHistoryCell *cell) {
        [cell configItemWithObj:self.assessVm.dataSource[indexPath.section]];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = tableBgColor;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.assessVm.assess = (CWTAssess*)self.assessVm.dataSource[indexPath.section];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[self.assessVm.assessCommand execute:self.assessVm.assess.log_id]subscribeError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } completed:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        CWTAssessmentResultViewController *resultVc  = [[CWTAssessmentResultViewController alloc] initWithObject:self.assessVm.assessResult];
        [self pushTo:resultVc];
        [self sendRequest];
    }];
}

-(UIImage*)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return [UIImage imageNamed:@"button_back_blue"];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    DLog(@"222222");
//    if (self.popBlock) {
//        self.popBlock();
//    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
