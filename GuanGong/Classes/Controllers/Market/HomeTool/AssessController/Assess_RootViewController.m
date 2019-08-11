//
//  Access_RootViewController.m
//  bluebook
//
//  Created by three on 2017/5/3.
//  Copyright © 2017年 iautos_miaoruiyuan. All rights reserved.
//

#import "Assess_RootViewController.h"
#import "CWTAssessmentResultViewController.h"
#import "CWTAssessHistoryViewController.h"

#import "ActionSheetDatePicker.h"
#import "AssessHomeViewModel.h"
#import "GGFormItem.h"
#import "CustomYMDPickerView.h"
#import "GGFooterView.h"
#import "StartAssessModel.h"
#import "UITableView+Common.h"
#import "UIAlertController+Common.h"
#import "UIButton+Common.h"
#import "GGLocationViewController.h"
#import "GGCarModelViewController.h"

#import "GGTitleValueCell.h"
#import "GGAddBankCardItemCell.h"

@interface Assess_RootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIButton *cityButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AssessHomeViewModel *assessViewModel;
@property (nonatomic, strong) NSDictionary *identifiers;

@property(nonatomic,strong)GGFooterView *tableFooterView;

@end

@implementation Assess_RootViewController

-(AssessHomeViewModel *)assessViewModel
{
    if (!_assessViewModel) {
        _assessViewModel = [[AssessHomeViewModel alloc] init];
    }
    return  _assessViewModel;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 49.0;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        
        CGFloat height = kScreenWidth *(320.00/750.00);
        UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
        headerImage.image = [UIImage imageNamed:@"bluebook_banner"];
        _tableView.tableHeaderView = headerImage;
        
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"车价评估";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"评估历史" style:UIBarButtonItemStylePlain target:self action:@selector(goToHistory)];
    
    [self setupTableview];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"AssessSuccessClose" object:nil] subscribeNext:^(id x) {
        self.cyl_tabBarController.selectedIndex = 1;
    }];
}

-(void)setupTableview{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView registerClass:[GGTitleValueCell class] forCellReuseIdentifier:kCellIdentifierTitleValue];
    [self.tableView registerClass:[GGAddBankCardItemCell class] forCellReuseIdentifier:kGGAddBankCardItemCellID];
    [self.tableView setTableFooterView:self.tableFooterView];
}

-(void)bindViewModel{
    @weakify(self);

    [RACObserve(self.assessViewModel, dataSource) subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.tableView reloadData];
        });
    }];
    
    RAC(self.tableFooterView, footerButton.enabled) =  self.assessViewModel.enableAssessSignal;
    
    [[self.tableFooterView.footerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        
        [self.tableFooterView.footerButton showIndicator];
        [[self.assessViewModel.assessCommand execute:@(NO)] subscribeError:^(NSError *error) {
            @strongify(self);
            [self.tableFooterView.footerButton hideIndicator];
            NSInteger code = [[error.userInfo valueForKey:@"code"] integerValue];
            if (code == 21301 || code == 20266) {
                [self showNoAssessResult];
            }
            
        } completed:^{
            @strongify(self);
            [self.tableFooterView.footerButton hideIndicator];
            CWTAssessmentResultViewController *resultVc  = [[CWTAssessmentResultViewController alloc] initWithObject:self.assessViewModel.assessResult];
            [self pushTo:resultVc];
        }];
    }];
}
-(void)showNoAssessResult{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"抱歉，该车暂无评估价格..." message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark- tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.assessViewModel sectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.assessViewModel itemCountAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGFormItem *item = [self.assessViewModel itemForIndexPath:indexPath];
    if (item.cellType == GGFormCellTypeNormal) {
        GGTitleValueCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTitleValue];
        [cell configItem:item];
        return cell;

    }else if (item.cellType == GGFormCellTypeTitleAndTextField){
        GGAddBankCardItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kGGAddBankCardItemCellID];
        [cell configItemShowRight:item];
        [[[cell.inputTextField rac_textSignal] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString *text) {
                self.assessViewModel.assessModel.mileage = text;
                item.obj = [NSString stringWithFormat:@"%@",self.assessViewModel.assessModel.mileage];
        }];
        return cell;
    }
    
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGFormItem *item = [self.assessViewModel itemForIndexPath:indexPath];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (item.isPicker) {
        if (!self.assessViewModel.assessModel.modelSimpleId) {
            [MBProgressHUD showError:@"请先选择车型 " toView:self.view];
            return;
        }
    }
    
    if (indexPath.row == 0) {
        GGLocationViewController *cityListVC = [[GGLocationViewController alloc] initWithItem:item];
        cityListVC.popHandler = ^(GGFormItem *item){
            self.assessViewModel.assessModel.city_id = [item.obj valueForKey:@"cityId"];
            item.obj =  [item.obj valueForKey:@"location"];
            [self.tableView reloadData];
        };
        [self pushTo:cityListVC];
    }else if (indexPath.row == 1){
        GGCarModelViewController *carModelVC = [[GGCarModelViewController alloc] initWithItem:item];
        carModelVC.popHandler = ^(GGFormItem *item){
            self.assessViewModel.assessModel.modelSimpleId  = item.obj[@"modelSimpleId"];
            self.assessViewModel.assessModel.purchaseYear  = item.obj[@"purchaseYear"];
            item.obj =  [item.obj valueForKey:@"title"];
            [self.tableView reloadData];
        };
        [self pushTo:carModelVC];
    }else if (indexPath.row == 2){
    
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        [minimumDateComponents setYear:[[NSDate date] year] - 17];
        NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
        
        @weakify(self);
        [ActionSheetDatePicker showPickerWithTitle:@"上牌日期"
                                    datePickerMode:UIDatePickerModeDate
                                      selectedDate:[NSDate date]
                                       minimumDate:minDate
                                       maximumDate:[NSDate date]
                                         doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                             @strongify(self);
                                             
                                             NSString *dateStr = [selectedDate stringWithFormat:@"yyyy-MM-dd"];
                                             item.obj = dateStr;
                                             self.assessViewModel.assessModel.first_reg_date = dateStr;
                                             [self.tableView reloadData];
                                             
                                         } cancelBlock:^(ActionSheetDatePicker *picker) {
                                             
                                         } origin:self.view];
        
//        NSString *min_year = @"1997";
//        if (item.pageContent != nil) {
//            min_year = [item.pageContent valueForKey:@"min_year"];
//        }
//        
//        CustomYMDPickerView *pickView = [[CustomYMDPickerView alloc] initWithMinYear:[min_year integerValue]];
//        [pickView show];
//        pickView.customYMDPickerBlock = ^(NSString *dateStr){
//            item.obj = dateStr;
//            self.assessViewModel.assessModel.first_reg_date  = item.obj;
//            [self.tableView reloadData];
//        };
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:12];
}

-(void)goToHistory{
    CWTAssessHistoryViewController *assessHistoryVC = [[CWTAssessHistoryViewController alloc] init];
    [MobClick event:@"valuationrecord"];
    [self.navigationController pushViewController:assessHistoryVC animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (GGFooterView *)tableFooterView
{
    if (!_tableFooterView) {
        _tableFooterView = [[GGFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60) andFootButtonTitle:@"估值"];
        [_tableFooterView.footerButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"508cee"]] forState:UIControlStateNormal];
    }
    return _tableFooterView;
}

@end
