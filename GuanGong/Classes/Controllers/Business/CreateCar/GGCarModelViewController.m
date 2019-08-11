//
//  GGCarModelViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarModelViewController.h"
#import "GGModelListViewController.h"
#import "GGCarModelViewModel.h"
#import "MultiTablesView.h"
#import "GGCarBrandCell.h"
#import "GGCarSeriesCell.h"
#import "GGCarYearCell.h"
#import "YZPullDownMenu.h"

#import "GGFormItem.h" 

@interface GGCarModelViewController ()<MultiTablesViewDataSource,MultiTablesViewDelegate>

@property(nonatomic,strong)MultiTablesView *tableView;
@property(nonatomic,strong)GGFormItem *item;
@property(nonatomic,strong)GGCarModelViewModel *carModelVM;

@end

@implementation GGCarModelViewController

- (instancetype)initWithItem:(GGFormItem *)item{
    if (self = [super init]) {
        self.item = item;
        _isCarsList = NO;
    }
    return self;
}

- (void)bindViewModel{
    [self.carModelVM.brandCommand execute:@(_isCarsList)];
    @weakify(self);
    [[self.carModelVM.brandCommand.executing skip:1]subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        }
    }];
    
    
    [[RACObserve(self.carModelVM, brands) skip:1] subscribeNext:^(id x) {
        [_tableView reloadData];
    }];
    
    [[RACObserve(self.carModelVM, series)skip:1] subscribeNext:^(id x) {
        [_tableView.currentTableView reloadData];
    }];
    
    [[RACObserve(self.carModelVM, years)skip:1] subscribeNext:^(id x) {
        [_tableView.currentTableView reloadData];
    }];
    
    [[RACObserve(self.carModelVM, models)skip:1] subscribeNext:^(NSArray *x) {
        self.item.pageContent = x;
        GGModelListViewController *modelListVC = [[GGModelListViewController alloc] initWithItem:_item];
        [modelListVC setPopHandler:^(GGFormItem *item) {
            if (self.popHandler) {
                self.popHandler(item);
            }
            [self pop];
        }];
        
        [GGCarModelViewController presentVC:modelListVC];
    }];


}

- (void)setupView{
    self.navigationItem.title = @"选择车型";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _tableView = ({
        MultiTablesView *view = [[MultiTablesView alloc]init];
        view.delegate = self;
        view.dataSource = self;
        view.nextTableViewHorizontalGap = 100;
        [[view tableViewAtIndex:0]registerClass:[GGCarBrandCell class] forCellReuseIdentifier:kCellIdentifierCreateCarBrand];
        [[view tableViewAtIndex:1]registerClass:[GGCarSeriesCell class] forCellReuseIdentifier:kCellIdentifierCreateCarSeries];
        [[view tableViewAtIndex:2]registerClass:[GGCarYearCell class] forCellReuseIdentifier:kCellIdentifierCreateCarYear];
        [self.view addSubview:view];
        view;
    });

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - MultiTablesViewDataSource
#pragma mark Levels
- (NSInteger)numberOfLevelsInMultiTablesView:(MultiTablesView *)multiTablesView {
    if (self.isCarsList) {
        return 2;
    }
    return 3;
}
#pragma mark Sections
- (NSInteger)multiTablesView:(MultiTablesView *)multiTablesView numberOfSectionsAtLevel:(NSInteger)level {
    switch (level) {
        case 0:
            return self.carModelVM.brands.count;
            break;
            
        case 1:
            return self.carModelVM.series.count;
            break;
            
        default:
            return 1;
            break;
    }
}

#pragma mark Rows
- (NSInteger)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level numberOfRowsInSection:(NSInteger)section {
    
    switch (level) {
        case 0:{
            NSArray *allKeys = [self.carModelVM.brands allKeysSorted];
            NSArray *sectionArray = self.carModelVM.brands[allKeys[section]];
            return sectionArray.count;
        }
            break;
            
        case 1:{
            GGCarSeries *series = self.carModelVM.series[section];
            return series.car_series.count;
        }
            break;

            
        default:{
            return self.carModelVM.years.count;
        }
            break;
    }
    
}
- (UITableViewCell *)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (level == 0) {
        GGCarBrandCell *cell = (GGCarBrandCell *)[multiTablesView dequeueReusableCellForLevel:level withIdentifier:kCellIdentifierCreateCarBrand];
        NSArray *allKeys = [self.carModelVM.brands allKeysSorted];
        GGCarBrand *brand = self.carModelVM.brands[allKeys[indexPath.section]][indexPath.row];
        cell.brand = brand;
        return cell;
        
    }else if (level == 1){
        GGCarSeriesCell *cell = (GGCarSeriesCell *)[multiTablesView dequeueReusableCellForLevel:level withIdentifier:kCellIdentifierCreateCarSeries];
        GGCarSeries *series = self.carModelVM.series[indexPath.section];
        cell.ser = series.car_series[indexPath.row];
        
        return cell;

    }else{
        GGCarYearCell *cell = (GGCarYearCell *)[multiTablesView dequeueReusableCellForLevel:level withIdentifier:kCellIdentifierCreateCarYear];
        
        id year = self.carModelVM.years[indexPath.row];
        if ([year isKindOfClass:[NSString class]]) {
            cell.year = year;
        }else if ([year isKindOfClass:[NSNumber class]]){
            cell.year = [year stringValue];
        }
        
        return cell;
    }
    
}


- (NSString *)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level titleForHeaderInSection:(NSInteger)section{
    if (level == 0) {
        NSArray *allKeys = [self.carModelVM.brands allKeysSorted];
        if (allKeys.count > section) {
            NSString *key = allKeys[section];
            return key;
        }
    }else if (level == 1){
        if (self.carModelVM.series.count > section) {
            GGCarSeries *series = self.carModelVM.series[section];
            return series.car_mfrs.iautos_name;
        }
    }
    else{
        return @"购买年份";
    }
    return nil;
}

- (NSString *)multiTablesView:(MultiTablesView *)multiTablesView titleForFixedTableHeaderViewAtLevel:(NSInteger)level{
    switch (level) {
        case 0:{
            return @"品牌";
        }
            break;
            
        case 1:{
            return @"车系";
        }
            break;
            
        default:
            return @"年份";
            break;
    }
}

#pragma mark - MultiTablesViewDelegate
#pragma mark Levels
- (void)multiTablesView:(MultiTablesView *)multiTablesView levelDidChange:(NSInteger)level {
    if (multiTablesView.currentTableViewIndex == level) {
        [multiTablesView.currentTableView deselectRowAtIndexPath:[multiTablesView.currentTableView indexPathForSelectedRow] animated:YES];
    }
}


#pragma mark Rows
- (CGFloat)multiTablesView:(MultiTablesView *)multiTablesView
                     level:(NSInteger)level
   heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 52;
    
}
- (void)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)multiTablesView:(MultiTablesView *)multiTablesView fixedTableHeaderViewAtLevel:(NSInteger)level{
    
    return nil;
}


- (void)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (level == 0) {
        NSArray *allKeys = [self.carModelVM.brands allKeysSorted];
        GGCarBrand *brand = self.carModelVM.brands[allKeys[indexPath.section]][indexPath.row];
        self.carModelVM.brandId = brand.brandId;
        self.carModelVM.brandName = brand.name;
        
        if (_isCarsList && indexPath.section == 0) {
            self.carModelVM.series = nil;
            multiTablesView.automaticPush = NO;
            if (level != multiTablesView.currentTableViewIndex) {
                [[multiTablesView tableViewAtIndex:1] reloadData];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:GGCarsListParameterNotification
                                                                object:self
                                                              userInfo:@{}];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote
                                                                object:self
                                                              userInfo:@{@"title":brand.name}];
            return;
        }
        
        multiTablesView.automaticPush = YES;
        [self.carModelVM.seriesCommand execute:@(_isCarsList)];
        
    }else if (level == 1){
        GGCarSeries *series = self.carModelVM.series[indexPath.section];
        GGSeries *ser = series.car_series[indexPath.row];
        self.carModelVM.seriesId = ser.seriesId;
        self.carModelVM.seriesName = ser.name;
        
        if (_isCarsList) {
            if (indexPath.section == 0) {
                [multiTablesView popCurrentTableViewAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:GGCarsListParameterNotification
                                                                    object:self
                                                                  userInfo:@{@"brandId":self.carModelVM.brandId}];
                [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote
                                                                    object:self
                                                                  userInfo:@{@"title":self.carModelVM.brandName}];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:GGCarsListParameterNotification
                                                                    object:self
                                                                  userInfo:@{@"brandId":@"",@"seriesId":ser.seriesId}];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote
                                                                    object:self
                                                                  userInfo:@{@"title":ser.name_show}];
            }
            
           
            return;
        }
        
        
        
        [self.carModelVM.yearsCommand execute:ser.seriesId];
       
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[self.carModelVM.modelsCommand execute:self.carModelVM.years[indexPath.row]]subscribeError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        } completed:^{
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        }];
    }
}



- (GGCarModelViewModel *)carModelVM{
    if (!_carModelVM) {
        _carModelVM = [[GGCarModelViewModel alloc] init];
    }
    return _carModelVM;
}


- (void)dealloc{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

@end
