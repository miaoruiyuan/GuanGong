//
//  CWTLimitStandardViewController.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/1/3.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTLimitStandardViewController.h"
#import "CWTLimitResultViewController.h"

#import "MultiTablesView.h"
#import "CWTLimitCity.h"

#import "GGToolApiManager.h"

@interface CWTLimitStandardViewController ()<MultiTablesViewDataSource,MultiTablesViewDelegate>

@property(nonatomic,strong)MultiTablesView *tableView;
@property(nonatomic,strong)NSMutableDictionary *resultDic;
@property(nonatomic,strong)NSArray *cityArray;
@property(nonatomic,strong)NSArray *keys;

@property(nonatomic,strong,readonly)RACCommand *searchCommand;

@end

@implementation CWTLimitStandardViewController{
}

- (void)setupView{
    self.navigationItem.title = @"所在地";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)bindViewModel{
    _keys = [NSArray array];
    @weakify(self);
    _searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[GGToolApiManager searchDischargeCityWithParames:nil] map:^id(NSArray *value) {
            
            @strongify(self);
            
            NSArray *result = [NSArray modelArrayWithClass:[CWTLimitCity class] json:value];
            
            NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:result.count];
            [result bk_each:^(CWTLimitCity *obj) {
                NSMutableArray *mArray  = [mDic objectForKey:obj.province];
                if (!mArray) {
                    mArray = [NSMutableArray array];
                    [mDic setObject:mArray forKey:obj.province];
                }
                [mArray addObject:obj];
            }];
            
            self.resultDic = mDic;
            self.keys = [[mDic allKeys]sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
                return [obj1 compare:obj2];
            }];
            
            return [RACSignal empty];
        }];
    }];
    
    [[_searchCommand execute:nil] subscribeCompleted:^{
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [[_searchCommand.executing skip:1] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        }
    }];
}


#pragma mark - MultiTablesViewDataSource
#pragma mark Levels
- (NSInteger)numberOfLevelsInMultiTablesView:(MultiTablesView *)multiTablesView {
    return 2;
}
#pragma mark Sections
- (NSInteger)multiTablesView:(MultiTablesView *)multiTablesView numberOfSectionsAtLevel:(NSInteger)level {
    return 1;
}

#pragma mark Rows
- (NSInteger)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level numberOfRowsInSection:(NSInteger)section {
    
    switch (level) {
        case 0:{
            return self.keys.count;
        }
            
            break;
            
        default:
             return self.cityArray.count;
            break;
    }
    
}
- (UITableViewCell *)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (level == 0) {
        UITableViewCell *provinceCell = [multiTablesView dequeueReusableCellForLevel:level withIdentifier:@"province"];
        if (!provinceCell) {
            provinceCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"province"];
            provinceCell.textLabel.font = [UIFont systemFontOfSize:15];
        }
    
        provinceCell.textLabel.text = self.keys[indexPath.row];
        return provinceCell;
    }else{
        UITableViewCell *cityCell = [multiTablesView dequeueReusableCellForLevel:level withIdentifier:@"city"];
        if (!cityCell) {
            cityCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"city"];
            cityCell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        CWTLimitCity *city = self.cityArray[indexPath.row];
        cityCell.textLabel.text = city.city;
        return cityCell;

    }
    
}


- (UIView *)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level heightForHeaderInSection:(NSInteger)section{
    return 0.f;
}
- (CGFloat)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level heightForFooterInSection:(NSInteger)section{
    return 0.f;
}



#pragma mark - MultiTablesViewDelegate

- (void)multiTablesView:(MultiTablesView *)multiTablesView levelDidChange:(NSInteger)level {
    //    if (multiTablesView.currentTableViewIndex == level) {
    //        [multiTablesView.currentTableView deselectRowAtIndexPath:[multiTablesView.currentTableView indexPathForSelectedRow] animated:YES];
    //    }
}


#pragma mark Rows
- (void)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}




- (void)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (level == 0) {
        self.cityArray = self.resultDic[self.keys[indexPath.row]];
        [multiTablesView.currentTableView reloadData];
    }else if (level == 1){
        multiTablesView.automaticPush = NO;
        CWTLimitCity *city = self.cityArray[indexPath.row];
        
        CWTLimitResultViewController *resultVc  = [[CWTLimitResultViewController alloc] initWithObject:city];
        [CWTLimitStandardViewController presentVC:resultVc];
    }
}

- (MultiTablesView *)tableView{
    if (!_tableView) {
        _tableView = [[MultiTablesView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.nextTableViewHorizontalGap = 100;
    }
    return _tableView;
}

- (void)dealloc{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    [_resultDic removeAllObjects];
    _resultDic = nil;
    _keys = nil;
    _cityArray = nil;
}

@end
