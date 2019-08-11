//
//  GGBankCountrywideViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/23.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBankCountrywideViewController.h"
#import "GGBankAddressViewController.h"
#import "MultiTablesView.h"
#import "GGBankProvince.h"
#import "GGBankAddressViewController.h"

@interface GGBankCountrywideViewController ()<MultiTablesViewDataSource,MultiTablesViewDelegate>
@property(nonatomic,strong)GGFormItem *item;

@property(nonatomic,strong)MultiTablesView *tableView;

@property(nonatomic,strong)NSArray *proviceArray;
@property(nonatomic,strong)GGBankProvince *province;
@property(nonatomic,strong)GGBankCity *city;
@property(nonatomic,strong)GGBankCountry *country;
@property(nonatomic,strong)NSNumber *bankCode;

@end

@implementation GGBankCountrywideViewController


- (id)initWithItem:(GGFormItem *)item{
    if (self = [super init]) {
        self.item = item;
        self.bankCode = item.obj;
    }
    return self;
}

- (void)bindViewModel
{
    [self initAreaData];
    
    [RACObserve(self, proviceArray)subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    }];
    
    [RACObserve(self, province)subscribeNext:^(id x) {
        [_tableView.currentTableView reloadData];
    }];
    
    [RACObserve(self, city)subscribeNext:^(id x) {
        [_tableView.currentTableView reloadData];
    }];
   
}

- (void)setupView{
    self.navigationItem.title = @"所在地";
   
    _tableView = ({
        MultiTablesView *view = [[MultiTablesView alloc]init];
        view.delegate = self;
        view.dataSource = self;
        view.nextTableViewHorizontalGap = 88;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
        }];
    
        view;
    });
}

#pragma mark- 初始化地区数据
- (void)initAreaData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path =  [[NSBundle mainBundle]pathForResource:@"bankInCountrywide" ofType:@"json"];
        self.proviceArray = [NSArray modelArrayWithClass:[GGBankProvince class] json:[NSData dataWithContentsOfFile:path]];
    });
}

#pragma mark - MultiTablesViewDataSource
#pragma mark Levels
- (NSInteger)numberOfLevelsInMultiTablesView:(MultiTablesView *)multiTablesView {
    return 3;
}

#pragma mark Sections
- (NSInteger)multiTablesView:(MultiTablesView *)multiTablesView numberOfSectionsAtLevel:(NSInteger)level
{
    return 1;
}

#pragma mark Rows
- (NSInteger)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level numberOfRowsInSection:(NSInteger)section
{
    switch (level) {
        case 0:
            return self.proviceArray.count;
            break;
        case 1:
            return self.province.citys.count;
            break;
        default:
            return self.city.areas.count;
            break;
    }
}

- (UITableViewCell *)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (level == 0) {
        UITableViewCell *provinceCell = [multiTablesView dequeueReusableCellForLevel:level withIdentifier:@"province"];
        if (!provinceCell) {
            provinceCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"province"];
            provinceCell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        GGBankProvince *province = self.proviceArray[indexPath.row];
        provinceCell.textLabel.text = province.nodeName;
        return provinceCell;
    }else if (level == 1){
        UITableViewCell *cityCell = [multiTablesView dequeueReusableCellForLevel:level withIdentifier:@"city"];
        if (!cityCell) {
            cityCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"city"];
            cityCell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        
        GGBankCity *city = self.province.citys[indexPath.row];
        cityCell.textLabel.text = city.areaName;
        return cityCell;
        
        
    }else{
        UITableViewCell *cityCell = [multiTablesView dequeueReusableCellForLevel:level withIdentifier:@"country"];
        if (!cityCell) {
            cityCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"country"];
            cityCell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        GGBankCountry *country = self.city.areas[indexPath.row];
        cityCell.textLabel.text = country.areaName;
        return cityCell;
    
    }
    
}

#pragma mark - MultiTablesViewDelegate
#pragma mark Levels
- (void)multiTablesView:(MultiTablesView *)multiTablesView levelDidChange:(NSInteger)level
{
//    if (multiTablesView.currentTableViewIndex == level) {
//        [multiTablesView.currentTableView deselectRowAtIndexPath:[multiTablesView.currentTableView indexPathForSelectedRow] animated:YES];
//    }
}


#pragma mark Rows
- (void)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)multiTablesView:(MultiTablesView *)multiTablesView fixedTableHeaderViewAtLevel:(NSInteger)level{
    
    return nil;
}

- (void)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (level) {
        case 0:
            self.province = self.proviceArray[indexPath.row];
            break;
            
        case 1:
            self.city = self.province.citys[indexPath.row];
            break;
            
        default:{
            self.country = self.city.areas[indexPath.row];
            self.item.obj = @{@"countyCode":self.country.oraAreaCode,
                              @"bankCode":self.bankCode};
            GGBankAddressViewController *addressVC = [[GGBankAddressViewController alloc] initWithItem:self.item];
            addressVC.popHandler = ^(GGFormItem *formItem){
                self.popHandler(formItem);
                [self.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:addressVC animated:YES];
        }
            break;
    }
}


@end
