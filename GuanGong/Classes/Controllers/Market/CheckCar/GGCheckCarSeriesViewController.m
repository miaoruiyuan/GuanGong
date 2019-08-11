//
//  GGCheckCarSeriesViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/7.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckCarSeriesViewController.h"
#import "MultiTablesView.h"
#import "GGCheckCarSeriesViewModel.h"

#import "GGCarBrandCell.h"
#import "GGCarSeriesCell.h"

@interface GGCheckCarSeriesViewController ()<MultiTablesViewDataSource,MultiTablesViewDelegate>
@property(nonatomic,strong)MultiTablesView *tableView;
@property(nonatomic,strong)GGFormItem *item;

@property(nonatomic,strong)GGCheckCarSeriesViewModel *carSeriesVM;


@end

@implementation GGCheckCarSeriesViewController
- (instancetype)initWithItem:(GGFormItem *)item{
    if (self = [super init]) {
        self.item = item;
    }
    return self;
}

- (void)bindViewModel{
    [self.carSeriesVM.brandCommand execute:0];
    
    [[RACObserve(self.carSeriesVM, brands) skip:1]subscribeNext:^(id x) {
        [_tableView reloadData];
    }];
    
    [[RACObserve(self.carSeriesVM, series)skip:1]subscribeNext:^(id x) {
        [_tableView.currentTableView reloadData];
    }];
    
}

- (void)setupView{
    self.navigationItem.title = @"选择车型";
    
    _tableView = ({
        MultiTablesView *view = [[MultiTablesView alloc]init];
        view.delegate = self;
        view.dataSource = self;
        view.nextTableViewHorizontalGap = 100;
        [[view tableViewAtIndex:0]registerClass:[GGCarBrandCell class] forCellReuseIdentifier:kCellIdentifierCreateCarBrand];
        [[view tableViewAtIndex:1]registerClass:[GGCarSeriesCell class] forCellReuseIdentifier:kCellIdentifierCreateCarSeries];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
        }];
        view;
    });

    
    
}

#pragma mark - MultiTablesViewDataSource
#pragma mark Levels
- (NSInteger)numberOfLevelsInMultiTablesView:(MultiTablesView *)multiTablesView {
    return 2;
}
#pragma mark Sections
- (NSInteger)multiTablesView:(MultiTablesView *)multiTablesView numberOfSectionsAtLevel:(NSInteger)level {
    switch (level) {
        case 0:
            return self.carSeriesVM.brands.count;
            break;
            
        default:
            return self.carSeriesVM.series.count;
            break;
    }
}

#pragma mark Rows
- (NSInteger)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level numberOfRowsInSection:(NSInteger)section {
    
    switch (level) {
        case 0:{
            NSArray *allKeys = [self.carSeriesVM.brands allKeysSorted];
            NSArray *sectionArray = self.carSeriesVM.brands[allKeys[section]];
            return sectionArray.count;
        }
            break;
            
        default:{
            GGCarSeries *series = self.carSeriesVM.series[section];
            return series.car_series.count;
        }
            break;
    }
    
}
- (UITableViewCell *)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (level == 0) {
        GGCarBrandCell *cell = (GGCarBrandCell *)[multiTablesView dequeueReusableCellForLevel:level withIdentifier:kCellIdentifierCreateCarBrand];
        NSArray *allKeys = [self.carSeriesVM.brands allKeysSorted];
        GGCarBrand *brand = self.carSeriesVM.brands[allKeys[indexPath.section]][indexPath.row];
        cell.brand = brand;
        return cell;
        
    }else{
        GGCarSeriesCell *cell = (GGCarSeriesCell *)[multiTablesView dequeueReusableCellForLevel:level withIdentifier:kCellIdentifierCreateCarSeries];
        GGCarSeries *series = self.carSeriesVM.series[indexPath.section];
        cell.ser = series.car_series[indexPath.row];

        return cell;
    }
    
}


- (NSString *)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level titleForHeaderInSection:(NSInteger)section{
    if (level == 0) {
        NSArray *allKeys = [self.carSeriesVM.brands allKeysSorted];
        if (allKeys.count > section) {
            NSString *key = allKeys[section];
            return key;
        }
    }else{
        if (self.carSeriesVM.series.count > section) {
            GGCarSeries *series = self.carSeriesVM.series[section];
            return series.car_mfrs.iautos_name;
        }
    }
    return nil;
}

- (NSString *)multiTablesView:(MultiTablesView *)multiTablesView titleForFixedTableHeaderViewAtLevel:(NSInteger)level{
    switch (level) {
        case 0:{
            return @"品牌";
        }
            break;
            
        default:
            return @"车系";
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
        NSArray *allKeys = [self.carSeriesVM.brands allKeysSorted];
        GGCarBrand *brand = self.carSeriesVM.brands[allKeys[indexPath.section]][indexPath.row];
        self.carSeriesVM.brandId = brand.brandId;
        self.carSeriesVM.brandName = brand.name;
        [self.carSeriesVM.seriesCommand execute:brand.brandId];
        
    }else{
        GGCarSeries *series = self.carSeriesVM.series[indexPath.section];
        GGSeries *ser = series.car_series[indexPath.row];
        
        self.carSeriesVM.seriesId = ser.seriesId;
        self.carSeriesVM.seriesName = ser.name;
        self.item.obj = @{@"brandId":self.carSeriesVM.brandId,
                          @"seriesId":self.carSeriesVM.seriesId,
                          @"title":[NSString stringWithFormat:@"%@%@",self.carSeriesVM.brandName,self.carSeriesVM.seriesName]};
        
        if (self.popHandler) {
            self.popHandler(self.item);
        }
        [self pop];
        
    }
}




- (GGCheckCarSeriesViewModel *)carSeriesVM{
    if (!_carSeriesVM) {
        _carSeriesVM = [[GGCheckCarSeriesViewModel alloc] init];
    }
    return _carSeriesVM;
}


- (void)dealloc{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}


@end
